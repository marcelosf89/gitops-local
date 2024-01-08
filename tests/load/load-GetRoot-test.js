import { check } from 'k6';
import http from 'k6/http';

const date = new Date();
const months = ["January", "February", "March", "April", "May", "June", "July",
"August", "September", "October", "November", "December"];

export let options = {
  tags: {
    testid: `GetRoot-${date.getDate()}-${months[date.getMonth()]}-${date.getFullYear()}-${date.getHours()}:${date.getMinutes()}`,
    name: 'GetRoot',
    scenario: 'GetRoot',
  },
};

export default function () {
  const url = `http://${__ENV.HOSTNAME}/`;

  const params = {
    headers: {
      'Content-Type': 'text/plain',
    },
  };

  const res = http.get(url, params);
  check(res, {
    'is status 200': (resp) => resp.status === 200,
  });
}