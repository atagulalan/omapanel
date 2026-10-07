import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import icon_requirements as checks


def result(code=0, output=''):
    return subprocess.CompletedProcess([], code, output, '')


class IconRequirements(unittest.TestCase):
    def test_missing_tools_use_omarchy_and_official_repository(self):
        with patch.object(checks.shutil, 'which', side_effect=lambda name: '/usr/bin/pacman' if name == 'pacman' else None), \
             patch.object(checks, 'run', return_value=result(output='Repository : extra\n')):
            answer = checks.requirements('tools')
        self.assertFalse(answer['ok'])
        self.assertIn('omarchy pkg add imagemagick', answer['error'])
        self.assertNotIn('pacman -S', answer['error'])
        with patch.object(checks.shutil, 'which', return_value='/usr/bin/pacman'), \
             patch.object(checks, 'run', return_value=result(output='Repository : custom\n')):
            self.assertNotIn('omarchy pkg add', checks.package_help(['imagemagick']))

    def test_clipboard_is_not_a_generation_requirement(self):
        with patch.object(checks.shutil, 'which', side_effect=lambda name: '/usr/bin/' + name if name != 'wl-copy' else None), \
             patch.object(checks, 'run', return_value=result(output='Repository : extra\n')):
            self.assertTrue(checks.requirements('tools')['ok'])
            answer = checks.requirements('clipboard')
        self.assertIn('omarchy pkg add wl-clipboard', answer['error'])

    def test_bootstrap_reports_missing_python_without_external_utilities(self):
        script = Path(__file__).resolve().parents[1] / 'scripts/icon-action.sh'
        with tempfile.TemporaryDirectory() as directory:
            answer = subprocess.run(['/bin/sh', str(script), 'generate'],
                                    env=dict(os.environ, PATH=directory), capture_output=True, text=True)
        self.assertEqual(answer.returncode, 1)
        self.assertIn('omarchy pkg add python', json.loads(answer.stdout)['error'])

    def test_default_agent_missing_or_unset(self):
        with patch.object(checks.shutil, 'which', side_effect=lambda name: '/usr/bin/omarchy' if name == 'omarchy' else None), \
             patch.object(checks, 'run', return_value=result(output='codex\n')):
            self.assertIn('omarchy default agent codex', checks.requirements('agent')['error'])
        with patch.object(checks.shutil, 'which', return_value='/usr/bin/omarchy'), \
             patch.object(checks, 'run', return_value=result()):
            self.assertIn('Setup → Default Agent', checks.requirements('agent')['error'])

    def test_cold_wrapper_is_not_executed(self):
        with tempfile.TemporaryDirectory() as directory:
            wrapper = Path(directory) / 'codex'
            wrapper.write_text('mise use -g codex\nexec mise x codex -- codex "$@"\n')
            with patch.object(checks.shutil, 'which', side_effect=lambda name: str(wrapper) if name == 'codex' else '/usr/bin/' + name), \
                 patch.object(checks, 'run', side_effect=[result(output='codex'), result(1)]) as runner:
                self.assertFalse(checks.requirements('agent')['ok'])
                self.assertEqual(runner.call_args_list[-1].args[0], ['mise', 'which', 'codex', '--tool=codex'])
                self.assertEqual(runner.call_count, 2)

    def test_codex_authentication_checked_each_request(self):
        with patch.object(checks.shutil, 'which', return_value='/missing/codex'), \
             patch.object(checks, 'run', side_effect=[result(output='codex'), result(), result(1),
                                                      result(output='codex'), result(), result()]):
            self.assertIn('codex login', checks.requirements('agent')['error'])
            self.assertTrue(checks.requirements('agent')['ok'])

    def test_unresponsive_tool_returns_actionable_failure(self):
        with patch.object(checks.shutil, 'which', return_value='/usr/bin/magick'), \
             patch.object(checks, 'run', side_effect=subprocess.TimeoutExpired('magick', 8)):
            self.assertIn('timed out', checks.requirements('tools')['error'])


if __name__ == '__main__':
    unittest.main()
