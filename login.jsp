<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta http-equiv="x-ua-compatible" content="ie=edge" />
    <title>Pantalla &Uacute;nica | Cuenta Cr&eacute;dito</title>
    <link
      href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet"
    />
    <link href="login/css/bootstrap.min.css" rel="stylesheet" />
    <link href="login/css/estilos-invex.css" rel="stylesheet" />
    <link rel="stylesheet" href="./css/login.css">
    <link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css"
  />
  </head>
  <body onpaste="return false">
    <!-- Vista Escritorio -->
    <div class="container-fluid bg-gradient vh-100">
      <div class="row">
        <!-- Marco -->
        <div class="col-md-4 offset-md-4 my-5">
          <div class="red-square" style="left: 15px"></div>
          <div class="shadow rounded-lg bg-white pt-4 px-3 pb-3">
            <!-- Logo -->
            <div class="row pb-4">
              <div class="col-12 text-center">
                <img
                  src="login/img/invex-logo.svg"
                  class="img-fluid logo-invex"
                />
              </div>
            </div>
            <!-- /Logo  -->

            <h3 class="main-color text-center mb-4">Te damos la bienvenida</h3>
            <form id="form1" action="../../commonauth" autocomplete="off">
              <div class="form-group mb-4">
                <div class="input-group">
                  <div class="input-group-prepend">
                    <span class="input-group-text">
                      <span class="material-icons"> person </span>
                    </span>
                  </div>
                  <input
                    id="username"
                    name="username"
                    type="text"
                    class="form-control"
                    maxlength="255"
                    placeholder="Usuario"
                    autocomplete="off"
                  />
                </div>
              </div>
              <div class="form-group mb-4">
                <div class="input-group">
                  <div class="input-group-prepend">
                    <span class="input-group-text">
                      <span class="material-icons"> lock </span>
                    </span>
                  </div>
                  <input
                    id="password"
                    name="password"
                    type="password"
                    class="form-control"
                    maxlength="255"
                    placeholder="Contrase&ntilde;a"
                    autocomplete="off"
                  />
                </div>
              </div>
              <input type="hidden" name="sessionDataKey" value='<%=Encode.forHtmlAttribute
              (request.getParameter("sessionDataKey"))%>'/>
              
              <div class="container-form">
                <div class="alert-message hide" id="alertMessage">
                  <span
                    ><i class="bi bi-x-circle-fill"></i>
                    <span id="textAlerMessage"></span
                  ></span>
                  <button id="btnCloseAlert" type="button">
                    <i class="bi bi-x"></i>
                  </button>
                </div>

              <button
                id="login-button"
                type="button"
                style="margin-top: 12px;"
                class="btn main-button btn-block mb-3"
                onclick="Mysubmit()"
              >
                <span id="button-text">Ingresar</span>
                <span class="" id="spinner"></span>
              </button>
            </form>

            <div class="text-center mt-3">
              <p class="mb-0">
                <a href="#" target="_self" class="main-link"
                  >Recupera tu contrase&ntilde;a</a
                >
              </p>
            </div>
          </div>
        </div>
        <!-- /Marco -->
      </div>
    </div>
    <!-- /Vista Escritorio -->

    <!-- JQuery -->
    <script type="text/javascript" src="login/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="login/js/bootstrap.min.js"></script>
    <script
      type="text/javascript"
      src="login/js/bootstrap.bundle.min.js"
    ></script>
    <script>
      const classesSpiner = "spinner-border spinner-border-sm";
      const spanSpinner = document.getElementById("spinner");
      const spanBtnText = document.getElementById("button-text");
      const loginButton = document.getElementById("login-button");
      const messageAlert = document.querySelector("#alertMessage");
      const buttonCloseMessageAlert = document.querySelector("#btnCloseAlert");
      const textMessageAlert = document.querySelector("#textAlerMessage");
      const errorMsgURL = "authFailureMsg";

      const showMessageError = (message) => {
        textMessageAlert.innerHTML = message;
        messageAlert.classList.remove('hide');
      }

      buttonCloseMessageAlert.addEventListener("click", function () {
        messageAlert.classList.add('hide');
      });

      function loadingButton(isLoading = true) {
        if (isLoading) {
          $("#spinner").addClass(classesSpiner);
          $("#button-text").text('')
          loginButton.disabled = true;
        } else {
          $("#spinner").removeClass(classesSpiner);
          $("#button-text").text('Ingresar')
          loginButton.disabled = false;
        }
      }

      function Mysubmit() {
        loadingButton(true);
        const username = $('#username').val();
        const pass = $('#password').val();
        messageAlert.classList.remove('hide');

        if (!username && !pass) {
          showMessageError('Ingresa tu usuario/contraseña.');
          loadingButton(false);
          return;
        } else {
          messageAlert.classList.remove('hide');
        } 

        if (username.includes("@invex.com")) {
          document.getElementById("username").value =
            username + "@carbon.super";
        }
        if (username.includes("@invex.com@carbon.super")) {
          document.getElementById("username").value = username;
        }

        $("#form1").submit();
        messageAlert.classList.remove('hide');

        setTimeout(() => {
          loadingButton(false);
        }, 3000);
      }

      $(document).ready(function () {
        const urlParams = new URLSearchParams(window.location.search);
        const myParam = urlParams.get(errorMsgURL);
        if (myParam) {
          showMessageError(myParam);
        }
      });
    </script>
  </body>
</html>
