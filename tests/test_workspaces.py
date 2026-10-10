import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
spec = importlib.util.spec_from_file_location('integration', Path(__file__).resolve().parents[1] / 'scripts/workspace-integration.py')
integration = importlib.util.module_from_spec(spec)
spec.loader.exec_module(integration)


class WorkspaceLifecycle(unittest.TestCase):
    def test_preserve_and_restore_original_placement(self):
        configuration = {'bar': {'layout': {'left': [{'id':'omarchy.menu'}, {'id':'omarchy.workspaces', 'custom':'kept'},
            {'id':integration.PANEL, 'groupRunningByWorkspace':True}], 'center':[], 'right':[]}}}
        calls = []
        with tempfile.TemporaryDirectory() as directory, patch.object(integration, 'config', return_value=configuration), \
             patch.object(integration, 'command', side_effect=lambda *args: calls.append(args) or ''):
            state = Path(directory) / 'state.json'
            integration.transition(True, state)
            snapshot = json.loads(state.read_text())
            self.assertEqual(snapshot['entries'][0]['index'], 1)
            self.assertEqual(snapshot['entries'][0]['entry']['custom'], 'kept')
            integration.transition(False, state)
            self.assertFalse(state.exists())
            self.assertIn(('omarchy', 'plugin', 'enable', 'omarchy.workspaces', '--section', 'left', '--index', '1'), calls)
            self.assertIn(('omarchy', 'bar', 'set', 'omarchy.workspaces', 'custom', '"kept"', '--json'), calls)

    def test_disabled_grouping_refuses_integration(self):
        configuration = {'bar': {'layout': {'left': [{'id':integration.PANEL, 'groupRunningByWorkspace':False}]}}}
        with tempfile.TemporaryDirectory() as directory, patch.object(integration, 'config', return_value=configuration):
            with self.assertRaises(ValueError):
                integration.transition(True, Path(directory) / 'state.json')


if __name__ == '__main__':
    unittest.main()
