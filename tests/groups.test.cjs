const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const groups = vm.createContext({});
vm.runInContext(fs.readFileSync('TaskGroups.js', 'utf8').replace(/^\.pragma.*$/gm, ''), groups);
const windows = [
    {address:'a', app:'foot', workspace:2}, {address:'b', app:'foot', workspace:2},
    {address:'c', app:'foot', workspace:4}, {address:'d', app:'chromium', workspace:3},
    {address:'e', app:'radio', workspace:3}, {address:'f', app:'gmail', workspace:3}
];
const build = (app, workspace) => groups.build(windows, app, workspace, w=>w.app, w=>w.workspace, w=>({label:w.app}));
assert.equal(build(false,false).length,6);
assert.equal(build(true,false).length,4);
assert.equal(build(false,true).length,6);
assert.equal(build(true,true).length,5);
assert.equal(build(true,true)[0].windows.length,2);
assert.equal(build(true,true)[4].workspace,4);
assert.equal(groups.nextIndex(3,-1,-1),0);
assert.equal(groups.nextIndex(3,2,-1),0);
assert.equal(groups.nextIndex(3,0,1),2);
windows[1].workspace=4;
assert.equal(build(true,true)[0].windows.length,1);
assert.equal(build(true,true)[4].windows.length,2);
windows.splice(0,1);
assert.equal(build(true,true).length,4);
console.log('App/workspace grouping, distinct webapps, moves, closures and cycling: passed');
