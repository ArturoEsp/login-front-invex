export const URL_FRONT = "https://localhost:9443";
export const CLIENT_ID = "OZfb2icUEXehApXC8UCaMlHwFXYa";
export const REDIRECT_URI = "https://invexluiss.modyo.cloud/loginunico/jwt&scope=openid FolioInternet,CUI,CodigoAplicacion";

/**
 * @param {string} msg Mensaje de error
 * @returns {string}
 */
export const modifyUrl = (msg) => {
  if (msg) return `${URL_FRONT}/oauth2/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&authFailureMsg=${msg}`;
  return `${URL_FRONT}/oauth2/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}`;
}

export const backLogin = () => {
  setTimeout(() => {
    window.location.href = `${URL_FRONT}/oauth2/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}`;
  }, 2000);
}