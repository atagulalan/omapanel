import os
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from tui_identity import agent_entries, commands, resolve


class TuiIdentities(unittest.TestCase):
    def test_marked_agents_distinct_from_plain_terminals(self):
        with tempfile.TemporaryDirectory() as directory:
            proc = Path(directory)
            for pid, name, children in ((100, 'foot', '101'), (101, 'codex', '102'), (102, 'bash', '')):
                root = proc / str(pid)
                root.joinpath('task', str(pid)).mkdir(parents=True)
                root.joinpath('comm').write_text(name)
                root.joinpath('cmdline').write_bytes(name.encode() + b'\0')
                root.joinpath('task', str(pid), 'children').write_text(children)
            agent = dict(id='omapanel.tui.codex', name='Codex', commands=['codex'])
            windows = [dict(key='a', pid=100, **{'class':'org.omarchy.agent'}),
                       dict(key='b', pid=100, **{'class':'foot'})]
            result = resolve(windows, [], [agent], proc)
            self.assertEqual(result['windows'], {'a':'omapanel.tui.codex'})
            self.assertNotIn('b', result['windows'])

    def test_tui_desktop_commands_and_shared_classes(self):
        self.assertEqual(commands('xdg-terminal-exec --app-id=TUI.float -e bash -c "dua i /"'), ['dua'])
        self.assertEqual(commands('omarchy-launch-tui --app-id=org.omarchy.btop btop'), ['btop'])
        apps = [dict(id='Docker', exec='xdg-terminal-exec --app-id=TUI.tile -e omarchy-launch-docker-tui'),
                dict(id='Disk Usage', exec='xdg-terminal-exec --app-id=TUI.float -e bash -c "dua i /"')]
        from unittest.mock import patch
        with patch('tui_identity.process_names', return_value=['foot', 'lazydocker']):
            result=resolve([dict(key='d',pid=1,**{'class':'TUI.tile'})],apps,[])
        self.assertEqual(result['windows'],{'d':'Docker'})
        apps.append(dict(id='Other Docker',exec=apps[0]['exec']))
        with patch('tui_identity.process_names', return_value=['lazydocker']):
            self.assertEqual(resolve([dict(key='d',pid=1,**{'class':'TUI.tile'})],apps,[])['windows'],{})

    def test_class_suffix_and_missing_process(self):
        app=dict(id='Btop',exec='omarchy-launch-tui btop')
        result=resolve([dict(key='b',pid=0,**{'class':'org.omarchy.btop'})],[app],[],Path('/missing/proc'))
        self.assertEqual(result['windows'],{'b':'Btop'})

    def test_agent_menu_name_and_original_icon(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory)
            menu=root/'default/omarchy/omarchy-menu.jsonc';menu.parent.mkdir(parents=True)
            menu.write_text('{ // comment\n "setup.default.agent.codex": {"label":"Codex",},}')
            icon=root/'shell/plugins/agents/assets/codex.svg';icon.parent.mkdir(parents=True);icon.write_text('<svg/>')
            entries=agent_entries(root)
            self.assertEqual(entries[0]['name'],'Codex')
            self.assertEqual(entries[0]['icon'],str(icon))
            self.assertIn('--app-id=org.omarchy.agent codex',entries[0]['launch'])


if __name__ == '__main__':
    unittest.main()
