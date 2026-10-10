import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from icon_render import icon_key, valid_agent
from icon_store import paths, prompt_for, scan


class IconLifecycle(unittest.TestCase):
    def test_separate_fallbacks_and_source_refresh(self):
        with tempfile.TemporaryDirectory() as directory, patch.dict(os.environ, {
            'XDG_CACHE_HOME': directory + '/cache', 'XDG_DATA_HOME': directory + '/data'}):
            source = Path(directory) / 'original.svg'
            source.write_text('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="7"/></svg>')
            app = dict(id='test.terminal', name='Foot', icon='missing.test.icon', source=str(source))
            initial = scan([app], True)
            self.assertEqual(initial['entries'][app['id']]['method'], 'reference')
            self.assertEqual(len(initial['missing']), 1)
            cache, agents = paths()
            agent = agents / (icon_key(app) + '.svg')
            agent.write_text(source.read_text())
            adopted = scan([app])
            self.assertTrue(adopted['agentMode'])
            self.assertEqual(adopted['missing'], [])
            self.assertEqual(adopted['entries'][app['id']]['selected'], agent.as_uri())
            old_hash = adopted['entries'][app['id']]['fingerprint']
            source.write_text(source.read_text().replace('r="7"', 'r="6"'))
            self.assertEqual(scan([app])['entries'][app['id']]['fingerprint'], old_hash)
            refreshed = scan([app], True)
            self.assertTrue(refreshed['missing'][0]['stale'])
            self.assertEqual(refreshed['entries'][app['id']]['selected'], refreshed['entries'][app['id']]['script'])
            self.assertIn(str(agent), prompt_for(refreshed))
            agent.write_text(source.read_text())
            self.assertEqual(scan([app])['missing'], [])
            agent.write_text('<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><rect width="24" height="24"/></svg>')
            self.assertFalse(valid_agent(agent))
            self.assertEqual(scan([app])['entries'][app['id']]['selected'], refreshed['entries'][app['id']]['script'])
            self.assertTrue(list((cache / 'script').iterdir()))

    def test_new_app_notification_is_deduplicated(self):
        with tempfile.TemporaryDirectory() as directory, patch.dict(os.environ, {
            'XDG_CACHE_HOME': directory + '/cache', 'XDG_DATA_HOME': directory + '/data'}):
            first = dict(id='a', name='Foot', icon='missing', source='')
            second = dict(id='b', name='Gmail', icon='missing', source='')
            scan([first])
            _, agents = paths()
            agent = agents / (icon_key(first) + '.svg')
            agent.write_text('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="6"/></svg>')
            scan([first])
            actual_run = subprocess.run
            notifications = []
            def run(command, **kwargs):
                if command[:3] == ['omarchy', 'notification', 'send']:
                    notifications.append(command)
                    return subprocess.CompletedProcess(command, 0)
                return actual_run(command, **kwargs)
            with patch('icon_store.subprocess.run', side_effect=run):
                result = scan([first, second], notify=True)
                scan([first, second], notify=True)
            self.assertEqual(len(notifications), 1)
            self.assertEqual([entry['id'] for entry in result['missing']], ['b'])

    def test_image_provider_source_resolves_installed_original(self):
        from icon_files import original_for
        app = {"icon": "image://icon/webapp", "source": "image://icon/webapp"}
        path = Path("/test/webapp.png")
        self.assertEqual(original_for(app, {"webapp": path}), path)

    def test_opaque_original_becomes_transparent_mask(self):
        with tempfile.TemporaryDirectory() as directory, patch.dict(os.environ, {
            'XDG_CACHE_HOME': directory + '/cache', 'XDG_DATA_HOME': directory + '/data'}):
            original = Path(directory) / 'opaque.png'
            subprocess.run(['magick', '-size', '64x64', 'xc:#202020', '-fill', '#60a060',
                            '-draw', 'rectangle 18,12 27,52 rectangle 38,26 47,52', str(original)], check=True)
            result = scan([dict(id='unfamiliar', name='Unfamiliar', icon='missing', source=str(original))], True)
            entry = result['entries']['unfamiliar']
            self.assertEqual(entry['method'], 'converted')
            self.assertTrue(valid_agent(Path(entry['script'].removeprefix('file://'))))


if __name__ == '__main__':
    unittest.main()
