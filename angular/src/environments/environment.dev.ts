const url = window['location']['href'];
const matches = url.match(/^http(s?)?\:\/\/([^\/?#]+)/);

export const environment = {
  production: false,
  baseUrl: matches[0],
  mockiBaseUrl: matches[0],
};
