<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BariX - Acesso ao Sistema</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">

    <style>
        :root {
            --barix-bg-green: #103823;
            --barix-wave-green: #0a2818;
            --barix-dark: #1e1e1e;
            --barix-light: #dcdcdc;
            --barix-amber: #f4b23e;
            --barix-amber-hover: #e09e28;
            --barix-btn-green: #133b27;
            --barix-btn-green-light: #196f3d;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        body {
            background-color: var(--barix-bg-green);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
            padding: 20px 0;
            position: relative;
        }

        /* Ondas orgânicas no fundo verde */
        body::before {
            content: "";
            position: absolute;
            bottom: -18%;
            left: -12%;
            width: 68vw;
            height: 58vh;
            background-color: var(--barix-wave-green);
            border-radius: 50% 50% 0 0;
            z-index: 0;
        }

        body::after {
            content: "";
            position: absolute;
            top: -12%;
            right: -12%;
            width: 58vw;
            height: 58vh;
            background-color: var(--barix-wave-green);
            border-radius: 0 0 0 65%;
            z-index: 0;
        }

        /* Cartão Principal */
        .auth-container {
            position: relative;
            z-index: 1;
            width: 920px;
            max-width: 95vw;
            min-height: 540px;
            background-color: var(--barix-light);
            border-radius: 34px;
            box-shadow: 0 22px 55px rgba(0, 0, 0, 0.48);
            overflow: hidden;
            display: flex;
        }

        /* Áreas dos Formulários */
        .form-box {
            position: absolute;
            top: 0;
            width: 50%;
            height: 100%;
            padding: 46px 54px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            transition: all 0.65s ease-in-out;
        }

        .login-box {
            right: 0;
            opacity: 1;
            z-index: 2;
        }

        .register-box {
            left: 0;
            opacity: 0;
            z-index: 1;
            pointer-events: none;
        }

        /* Estado Invertido: Criar Conta */
        .auth-container.modo-cadastro .login-box {
            opacity: 0;
            z-index: 1;
            pointer-events: none;
            transform: translateX(-20px);
        }

        .auth-container.modo-cadastro .register-box {
            opacity: 1;
            z-index: 2;
            pointer-events: all;
            transform: translateX(0);
        }

        .form-title {
            font-size: 2.35rem;
            font-weight: 800;
            color: #000000;
            margin-bottom: 26px;
            text-align: center;
        }

        .input-group-barix {
            margin-bottom: 16px;
        }

        .input-group-barix label {
            display: block;
            font-weight: 700;
            font-size: 0.92rem;
            color: #111111;
            margin-bottom: 6px;
        }

        .input-group-barix input {
            width: 100%;
            height: 42px;
            background-color: #ffffff;
            border: 2px solid transparent;
            border-radius: 10px;
            padding: 0 14px;
            font-size: 0.95rem;
            color: #1e1e1e;
            outline: none;
            transition: border-color 0.2s;
        }

        .input-group-barix input:focus {
            border-color: var(--barix-bg-green);
        }

        .btn-submit-barix {
            display: block;
            width: 155px;
            margin: 22px auto 0 auto;
            padding: 10px 0;
            background-color: var(--barix-amber);
            color: #000000;
            font-weight: 700;
            font-size: 0.95rem;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.15s;
        }

        .btn-submit-barix:hover {
            background-color: var(--barix-amber-hover);
            transform: translateY(-1px);
        }

        /* Painel Escuro Deslizante ("Bem Vindo(a) ao BariX") */
        .overlay-panel {
            position: absolute;
            top: 0;
            left: 0;
            width: 50%;
            height: 100%;
            background-color: var(--barix-dark);
            color: #ffffff;
            border-radius: 34px;
            z-index: 10;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 40px;
            transition: transform 0.65s cubic-bezier(0.68, -0.10, 0.265, 1.10);
        }

        .auth-container.modo-cadastro .overlay-panel {
            transform: translateX(100%);
        }

        .welcome-title {
            font-size: 2.35rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 54px;
        }

        .welcome-subtitle {
            font-size: 0.85rem;
            color: #d0d0d0;
            margin-bottom: 14px;
        }

        .btn-toggle-barix {
            background-color: var(--barix-btn-green);
            color: #ffffff;
            font-weight: 700;
            font-size: 0.95rem;
            padding: 10px 30px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.15s;
        }

        .btn-toggle-barix:hover {
            background-color: #1c5439;
            transform: translateY(-1px);
        }


        .alert-barix {
            font-size: 0.85rem;
            padding: 8px 12px;
            border-radius: 8px;
            margin-bottom: 14px;
            text-align: center;
        }

        .oculto {
            display: none;
        }

        @media (max-width: 768px) {
            .auth-container {
                flex-direction: column;
                min-height: 920px;
            }
            .form-box, .overlay-panel {
                width: 100%;
                height: 50%;
            }
            .form-box {
                padding: 25px 24px;
            }
            .login-box {
                top: 50%;
                right: auto;
                left: 0;
            }
            .register-box {
                top: 0;
            }
            .auth-container.modo-cadastro .overlay-panel {
                transform: translateY(100%);
            }
        }
    </style>
</head>
<body>

<div class="auth-container ${abrirCadastro ? 'modo-cadastro' : ''}" id="authContainer">

    <!-- Painel Escuro Deslizante -->
    <div class="overlay-panel">
        <h1 class="welcome-title">Bem Vindo(a)<br>ao BariX</h1>
        <c:if test="${cadastroHabilitado}">
            <p class="welcome-subtitle" id="welcomeText">
                    ${abrirCadastro ? 'Já tem uma conta?' : 'Ainda não tem uma conta?'}
            </p>
            <button type="button" class="btn-toggle-barix" id="toggleModeBtn">
                    ${abrirCadastro ? 'Fazer Login' : 'Criar Conta'}
            </button>
        </c:if>
    </div>

    <!-- Formulário de Login (Inicia à direita) -->
    <div class="form-box login-box" ${abrirCadastro ? 'inert' : ''}>
        <h2 class="form-title">Fazer Login</h2>

        <div class="alert alert-danger alert-barix ${empty erroLogin ? 'oculto' : ''}">
            <c:out value="${erroLogin}"/>
        </div>
        <div class="alert alert-success alert-barix ${empty sucessoCadastro ? 'oculto' : ''}">
            <c:out value="${sucessoCadastro}"/>
        </div>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <div class="input-group-barix">
                <label for="loginUsuario">Usuário</label>
                <input type="text" id="loginUsuario" name="usuario" maxlength="60" required autocomplete="username">
            </div>

            <div class="input-group-barix">
                <label for="loginSenha">Senha</label>
                <input type="password" id="loginSenha" name="senha" maxlength="128" required autocomplete="current-password">
            </div>

            <button type="submit" class="btn-submit-barix">Entrar</button>
        </form>
    </div>

    <!-- Formulário de Criar Conta (Inverte para a esquerda) -->
    <c:if test="${cadastroHabilitado}">
        <div class="form-box register-box" ${abrirCadastro ? '' : 'inert'}>
            <h2 class="form-title">Criar Conta</h2>

            <div class="alert alert-danger alert-barix ${empty erroCadastro ? 'oculto' : ''}">
                <c:out value="${erroCadastro}"/>
            </div>

            <form action="${pageContext.request.contextPath}/cadastro" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="input-group-barix">
                    <label for="cadNome">Nome Completo</label>
                    <input type="text" id="cadNome" name="nomeCompleto" maxlength="120" required>
                </div>

                <div class="input-group-barix">
                    <label for="cadUsuario">Usuário</label>
                    <input type="text" id="cadUsuario" name="usuario" maxlength="60" required autocomplete="username">
                </div>

                <div class="input-group-barix">
                    <label for="cadSenha">Senha</label>
                    <input type="password" id="cadSenha" name="senha"
                           minlength="15" maxlength="128"
                           title="A senha deve ter entre 15 e 128 caracteres."
                           required autocomplete="new-password">
                </div>

                <button type="submit" class="btn-submit-barix">Criar conta</button>
            </form>
        </div>
    </c:if>

</div>

<script>
    const authContainer = document.getElementById('authContainer');
    const toggleBtn = document.getElementById('toggleModeBtn');
    const welcomeText = document.getElementById('welcomeText');

    if (toggleBtn) {
        toggleBtn.addEventListener('click', () => {
            authContainer.classList.toggle('modo-cadastro');
            const emCadastro = authContainer.classList.contains('modo-cadastro');
            authContainer.querySelector('.login-box').inert = emCadastro;
            authContainer.querySelector('.register-box').inert = !emCadastro;
            welcomeText.textContent = emCadastro ? 'Já tem uma conta?' : 'Ainda não tem uma conta?';
            toggleBtn.textContent = emCadastro ? 'Fazer Login' : 'Criar Conta';
        });
    }
</script>

</body>
</html>