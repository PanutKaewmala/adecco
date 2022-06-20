const url = window.location.href;
const matches = url.match(/^http(s?)?\:\/\/([^\/?#]+)/);

export const environment = {
  production: true,
  baseUrl: matches[0],
  mockiBaseUrl: matches[0],
};
