import test from 'tape';
import Hello from '../scripts/Hello';

test('Hello', t => {
  t.ok(Hello instanceof Function, 'should be a function');
  t.end();
});
