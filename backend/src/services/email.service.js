const { Resend } = require('resend');

if (!process.env.RESEND_API_KEY) {
  throw new Error('RESEND_API_KEY environment variable is required');
}

const resend = new Resend(process.env.RESEND_API_KEY);
const FROM = process.env.FROM_EMAIL || 'Gravity Tech <noreply@gravitytech.com>';

/**
 * Envía el email de recuperación de contraseña.
 * @param {string} to      - Email del destinatario
 * @param {string} name    - Nombre del usuario
 * @param {string} link    - URL con el token de reset
 */
const sendPasswordReset = async (to, name, link) => {
  await resend.emails.send({
    from: FROM,
    to,
    subject: 'Recuperar contraseña — Gravity Tech',
    html: `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Recuperar contraseña</title>
</head>
<body style="margin:0;padding:0;background:#0a0e1a;font-family:system-ui,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#0a0e1a;padding:40px 0;">
    <tr>
      <td align="center">
        <table width="520" cellpadding="0" cellspacing="0" style="background:#131929;border-radius:16px;border:1px solid #1e2d4a;overflow:hidden;">
          <tr>
            <td style="background:linear-gradient(135deg,#4c2f9e,#6b21a8);padding:32px 40px;text-align:center;">
              <p style="margin:0;font-size:28px;font-weight:700;color:#ffffff;letter-spacing:-0.5px;">Gravity Tech 💻</p>
            </td>
          </tr>
          <tr>
            <td style="padding:40px;">
              <p style="margin:0 0 8px;font-size:22px;font-weight:600;color:#e8eaf6;">Hola, ${name}</p>
              <p style="margin:0 0 28px;font-size:15px;color:#8892b0;line-height:1.6;">
                Recibimos una solicitud para restablecer la contraseña de tu cuenta.<br>
                Haz clic en el botón para continuar:
              </p>
              <table cellpadding="0" cellspacing="0" style="margin:0 0 28px;">
                <tr>
                  <td style="background:linear-gradient(135deg,#4c2f9e,#7c3aed);border-radius:10px;">
                    <a href="${link}" style="display:inline-block;padding:14px 32px;font-size:15px;font-weight:600;color:#ffffff;text-decoration:none;">
                      Restablecer contraseña
                    </a>
                  </td>
                </tr>
              </table>
              <p style="margin:0 0 4px;font-size:13px;color:#8892b0;">
                El enlace expira en <strong style="color:#c4b5fd;">1 hora</strong>.
              </p>
              <p style="margin:0;font-size:13px;color:#8892b0;">
                Si no solicitaste este cambio, puedes ignorar este correo.
              </p>
              <hr style="border:none;border-top:1px solid #1e2d4a;margin:32px 0;">
              <p style="margin:0;font-size:12px;color:#4a5568;text-align:center;">
                Si el botón no funciona, copia este enlace en tu navegador:<br>
                <a href="${link}" style="color:#7c3aed;word-break:break-all;">${link}</a>
              </p>
            </td>
          </tr>
          <tr>
            <td style="padding:20px 40px;background:#0d1526;text-align:center;">
              <p style="margin:0;font-size:12px;color:#4a5568;">
                © ${new Date().getFullYear()} Gravity Tech. Todos los derechos reservados.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`,
  });
};

module.exports = { sendPasswordReset };
