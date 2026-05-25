-- ============================================================
-- Cuentas de prueba Gravity Tech
-- Generadas con bcrypt cost=12
-- ============================================================
INSERT INTO ecommerce.usuario (nombre, email, password_hash, rol) VALUES
  ('Admin Store',     'admin@gravitytech.com',   '$2b$12$/8LQP4qDk6d0Dx4P8PNXFu5ZVH0gpyhcPw.5O5.rycv3p7HFc1Vk2', 'administrador'),
  ('Cliente Demo',    'cliente@gravitytech.com', '$2b$12$SQFzC/nt0p3zzYt4jREeKuiCV.kbHuv8S6vcDQSmTj93hsWivzYIO', 'cliente'),
  ('Trabajador Demo', 'worker@gravitytech.com',  '$2b$12$5hcrdMSdnclLSo6RM1K1Q.7gspSJvcQE0AlmibV3GMdO0DG3H7UDu', 'trabajador')
ON CONFLICT (email) DO NOTHING;
