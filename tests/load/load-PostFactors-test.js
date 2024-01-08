import http from 'k6/http';
import { check } from 'k6';

const months = ["January", "February", "March", "April", "May", "June", "July",
"August", "September", "October", "November", "December"];

const date = new Date();

export let options = {
  tags: {
    testid: `PostFactors-${date.getDate()}-${months[date.getMonth()]}-${date.getFullYear()}-${date.getHours()}:${date.getMinutes()}`,
    name: 'PostFactors',
    scenario: 'PostFactors',
  },
};

function makeid(length) {
  let result = '';
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const charactersLength = characters.length;
  let counter = 0;
  while (counter < length) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
    counter += 1;
  }
  return result;
}

export default function () {
  const url = `http://${__ENV.HOSTNAME}/factors`;

  // send post request with custom header and payload
  for (let id = 1; id <= 10000; id++) {
    const randomNumber = Math.floor(Math.random() * 100); 

    const res = http.post(url, `number=${randomNumber}`, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });
    check(res, {
      'is status 200': (resp) => resp.status === 200,
    });
  }
}

