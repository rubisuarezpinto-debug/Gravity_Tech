const nodemailer = require('nodemailer');

const transportador = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,       
        pass: process.env.EMAIL_PASSWORD   
    }
});

const enviarCodigoCorreo = async (v_correo_destino, v_codigo) => {
    const opcionesCorreo = {
        from: `"Gravity Tech 🚀" <${process.env.EMAIL_USER}>`,
        to: v_correo_destino,
        subject: 'Código de Verificación - Gravity Tech',
        html: `
            <div style="font-family: Arial, sans-serif; text-align: center; padding: 20px; background-color: #121212; color: white; border-radius: 10px;">
                <h2 style="color: #6200EE;">¡Bienvenido a Gravity Tech!</h2>
                <p>Para completar tu registro, ingresa el siguiente código de 6 dígitos en la aplicación:</p>
                <div style="font-size: 32px; font-weight: bold; color: #FF4081; letter-spacing: 5px; margin: 20px 0; padding: 10px; background-color: #1E1E1E; display: inline-block; border-radius: 5px;">
                    ${v_codigo}
                </div>
                <p style="font-size: 12px; color: #888;">Este código expirará pronto. Si no solicitaste este registro, puedes ignorar este correo.</p>
            </div>
        `
    };

    return await transportador.sendMail(opcionesCorreo);
};

module.exports = { enviarCodigoCorreo };