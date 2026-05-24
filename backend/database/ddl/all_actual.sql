--
-- PostgreSQL database dump
--

\restrict jva2XkwGPkjcuHyza2TGqGlzGWKoLf8ucDodongkoq6gh6ncYlSgE5YTy90Lb6g

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ecommerce; Type: SCHEMA; Schema: -; Owner: ecommerce_admin_rubi
--

CREATE SCHEMA ecommerce;


ALTER SCHEMA ecommerce OWNER TO ecommerce_admin_rubi;

--
-- Name: SCHEMA ecommerce; Type: COMMENT; Schema: -; Owner: ecommerce_admin_rubi
--

COMMENT ON SCHEMA ecommerce IS 'Esquema principal para el eCommerce';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auditoria; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.auditoria (
    id_auditoria integer NOT NULL,
    id_usuario integer NOT NULL,
    accion character varying(100) NOT NULL,
    entidad character varying(100) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    detalle text
);


ALTER TABLE ecommerce.auditoria OWNER TO ecommerce_admin_rubi;

--
-- Name: auditoria_id_auditoria_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.auditoria_id_auditoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.auditoria_id_auditoria_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: auditoria_id_auditoria_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.auditoria_id_auditoria_seq OWNED BY ecommerce.auditoria.id_auditoria;


--
-- Name: carrito; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.carrito (
    id_carrito integer NOT NULL,
    id_usuario integer NOT NULL,
    estado character varying(20) DEFAULT 'ABIERTO'::character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE ecommerce.carrito OWNER TO ecommerce_admin_rubi;

--
-- Name: carrito_id_carrito_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.carrito_id_carrito_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.carrito_id_carrito_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: carrito_id_carrito_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.carrito_id_carrito_seq OWNED BY ecommerce.carrito.id_carrito;


--
-- Name: carrito_item; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.carrito_item (
    id_carrito_item integer NOT NULL,
    id_carrito integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad integer DEFAULT 1 NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE ecommerce.carrito_item OWNER TO ecommerce_admin_rubi;

--
-- Name: carrito_item_id_carrito_item_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.carrito_item_id_carrito_item_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.carrito_item_id_carrito_item_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: carrito_item_id_carrito_item_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.carrito_item_id_carrito_item_seq OWNED BY ecommerce.carrito_item.id_carrito_item;


--
-- Name: categoria; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.categoria (
    id_categoria integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE ecommerce.categoria OWNER TO ecommerce_admin_rubi;

--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.categoria_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.categoria_id_categoria_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.categoria_id_categoria_seq OWNED BY ecommerce.categoria.id_categoria;


--
-- Name: cupon; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.cupon (
    id_cupon integer NOT NULL,
    codigo character varying(50) NOT NULL,
    porcentaje_descuento numeric(5,2) NOT NULL,
    activo boolean DEFAULT true,
    fecha_expiracion date,
    CONSTRAINT cupon_porcentaje_descuento_check CHECK (((porcentaje_descuento > (0)::numeric) AND (porcentaje_descuento <= (100)::numeric)))
);


ALTER TABLE ecommerce.cupon OWNER TO postgres;

--
-- Name: cupon_id_cupon_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.cupon_id_cupon_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.cupon_id_cupon_seq OWNER TO postgres;

--
-- Name: cupon_id_cupon_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.cupon_id_cupon_seq OWNED BY ecommerce.cupon.id_cupon;


--
-- Name: direccion; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.direccion (
    id_direccion integer NOT NULL,
    id_usuario integer NOT NULL,
    direccion character varying(255) NOT NULL,
    ciudad character varying(100) NOT NULL,
    pais character varying(100) NOT NULL,
    latitud numeric(10,8),
    longitud numeric(11,8),
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE ecommerce.direccion OWNER TO ecommerce_admin_rubi;

--
-- Name: direccion_id_direccion_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.direccion_id_direccion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.direccion_id_direccion_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: direccion_id_direccion_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.direccion_id_direccion_seq OWNED BY ecommerce.direccion.id_direccion;


--
-- Name: estado_orden; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.estado_orden (
    id_estado integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE ecommerce.estado_orden OWNER TO ecommerce_admin_rubi;

--
-- Name: estado_orden_id_estado_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.estado_orden_id_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.estado_orden_id_estado_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: estado_orden_id_estado_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.estado_orden_id_estado_seq OWNED BY ecommerce.estado_orden.id_estado;


--
-- Name: favorito; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.favorito (
    id_favorito integer NOT NULL,
    id_usuario integer NOT NULL,
    id_producto integer NOT NULL,
    fecha_agregado timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE ecommerce.favorito OWNER TO postgres;

--
-- Name: favorito_id_favorito_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.favorito_id_favorito_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.favorito_id_favorito_seq OWNER TO postgres;

--
-- Name: favorito_id_favorito_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.favorito_id_favorito_seq OWNED BY ecommerce.favorito.id_favorito;


--
-- Name: imagen; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.imagen (
    id_imagen integer NOT NULL,
    id_producto integer NOT NULL,
    url character varying(500) NOT NULL,
    es_principal boolean DEFAULT false,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE ecommerce.imagen OWNER TO postgres;

--
-- Name: imagen_id_imagen_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.imagen_id_imagen_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.imagen_id_imagen_seq OWNER TO postgres;

--
-- Name: imagen_id_imagen_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.imagen_id_imagen_seq OWNED BY ecommerce.imagen.id_imagen;


--
-- Name: marca; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.marca (
    id_marca integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE ecommerce.marca OWNER TO ecommerce_admin_rubi;

--
-- Name: marca_id_marca_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.marca_id_marca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.marca_id_marca_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: marca_id_marca_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.marca_id_marca_seq OWNED BY ecommerce.marca.id_marca;


--
-- Name: metodo_pago; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.metodo_pago (
    id_metodo_pago integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE ecommerce.metodo_pago OWNER TO ecommerce_admin_rubi;

--
-- Name: metodo_pago_id_metodo_pago_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.metodo_pago_id_metodo_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.metodo_pago_id_metodo_pago_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: metodo_pago_id_metodo_pago_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.metodo_pago_id_metodo_pago_seq OWNED BY ecommerce.metodo_pago.id_metodo_pago;


--
-- Name: orden; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.orden (
    id_orden integer NOT NULL,
    id_usuario integer NOT NULL,
    id_direccion integer NOT NULL,
    id_metodo_pago integer NOT NULL,
    id_tipo_envio integer NOT NULL,
    id_estado integer NOT NULL,
    total numeric(10,2) DEFAULT 0.00 NOT NULL,
    fecha_orden timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE ecommerce.orden OWNER TO ecommerce_admin_rubi;

--
-- Name: orden_id_orden_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.orden_id_orden_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.orden_id_orden_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: orden_id_orden_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.orden_id_orden_seq OWNED BY ecommerce.orden.id_orden;


--
-- Name: orden_item; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.orden_item (
    id_orden_item integer NOT NULL,
    id_orden integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad integer DEFAULT 1 NOT NULL,
    precio_unitario numeric(10,2) NOT NULL
);


ALTER TABLE ecommerce.orden_item OWNER TO ecommerce_admin_rubi;

--
-- Name: orden_item_id_orden_item_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.orden_item_id_orden_item_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.orden_item_id_orden_item_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: orden_item_id_orden_item_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.orden_item_id_orden_item_seq OWNED BY ecommerce.orden_item.id_orden_item;


--
-- Name: pago; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.pago (
    id_pago integer NOT NULL,
    id_orden integer NOT NULL,
    monto numeric(10,2) NOT NULL,
    referencia character varying(150),
    estado character varying(50) NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE ecommerce.pago OWNER TO ecommerce_admin_rubi;

--
-- Name: pago_id_pago_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.pago_id_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.pago_id_pago_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: pago_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.pago_id_pago_seq OWNED BY ecommerce.pago.id_pago;


--
-- Name: producto; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.producto (
    id_producto integer NOT NULL,
    nombre character varying(200) NOT NULL,
    descripcion text,
    precio numeric(10,2) NOT NULL,
    stock integer DEFAULT 0,
    sku character varying(50),
    id_marca integer NOT NULL,
    estado character varying(20) DEFAULT 'DISPONIBLE'::character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT producto_precio_check CHECK ((precio >= (0)::numeric)),
    CONSTRAINT producto_stock_check CHECK ((stock >= 0))
);


ALTER TABLE ecommerce.producto OWNER TO ecommerce_admin_rubi;

--
-- Name: producto_categoria; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.producto_categoria (
    id_producto integer NOT NULL,
    id_categoria integer NOT NULL
);


ALTER TABLE ecommerce.producto_categoria OWNER TO ecommerce_admin_rubi;

--
-- Name: producto_id_producto_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.producto_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.producto_id_producto_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: producto_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.producto_id_producto_seq OWNED BY ecommerce.producto.id_producto;


--
-- Name: resena; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.resena (
    id_resena integer NOT NULL,
    id_usuario integer NOT NULL,
    id_producto integer NOT NULL,
    comentario text,
    puntuacion integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT resena_puntuacion_check CHECK (((puntuacion >= 1) AND (puntuacion <= 5)))
);


ALTER TABLE ecommerce.resena OWNER TO ecommerce_admin_rubi;

--
-- Name: resena_id_resena_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.resena_id_resena_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.resena_id_resena_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: resena_id_resena_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.resena_id_resena_seq OWNED BY ecommerce.resena.id_resena;


--
-- Name: tipo_envio; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.tipo_envio (
    id_tipo_envio integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE ecommerce.tipo_envio OWNER TO ecommerce_admin_rubi;

--
-- Name: tipo_envio_id_tipo_envio_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.tipo_envio_id_tipo_envio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.tipo_envio_id_tipo_envio_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: tipo_envio_id_tipo_envio_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.tipo_envio_id_tipo_envio_seq OWNED BY ecommerce.tipo_envio.id_tipo_envio;


--
-- Name: usuario; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.usuario (
    id_usuario integer NOT NULL,
    nombre character varying(150),
    email character varying(150) NOT NULL,
    password_hash character varying(255) NOT NULL,
    rol character varying(20) DEFAULT 'cliente'::character varying,
    estado character varying(20) DEFAULT 'ACTIVO'::character varying,
    telefono character varying(20),
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    sms_code character varying(6),
    sms_expires_at timestamp without time zone
);


ALTER TABLE ecommerce.usuario OWNER TO ecommerce_admin_rubi;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE SEQUENCE ecommerce.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.usuario_id_usuario_seq OWNER TO ecommerce_admin_rubi;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER SEQUENCE ecommerce.usuario_id_usuario_seq OWNED BY ecommerce.usuario.id_usuario;


--
-- Name: usuario_metodo_pago; Type: TABLE; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

CREATE TABLE ecommerce.usuario_metodo_pago (
    id_usuario integer NOT NULL,
    id_metodo_pago integer NOT NULL,
    estado character varying(20) DEFAULT 'ACTIVO'::character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE ecommerce.usuario_metodo_pago OWNER TO ecommerce_admin_rubi;

--
-- Name: auditoria id_auditoria; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.auditoria ALTER COLUMN id_auditoria SET DEFAULT nextval('ecommerce.auditoria_id_auditoria_seq'::regclass);


--
-- Name: carrito id_carrito; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.carrito ALTER COLUMN id_carrito SET DEFAULT nextval('ecommerce.carrito_id_carrito_seq'::regclass);


--
-- Name: carrito_item id_carrito_item; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.carrito_item ALTER COLUMN id_carrito_item SET DEFAULT nextval('ecommerce.carrito_item_id_carrito_item_seq'::regclass);


--
-- Name: categoria id_categoria; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.categoria ALTER COLUMN id_categoria SET DEFAULT nextval('ecommerce.categoria_id_categoria_seq'::regclass);


--
-- Name: cupon id_cupon; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.cupon ALTER COLUMN id_cupon SET DEFAULT nextval('ecommerce.cupon_id_cupon_seq'::regclass);


--
-- Name: direccion id_direccion; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.direccion ALTER COLUMN id_direccion SET DEFAULT nextval('ecommerce.direccion_id_direccion_seq'::regclass);


--
-- Name: estado_orden id_estado; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.estado_orden ALTER COLUMN id_estado SET DEFAULT nextval('ecommerce.estado_orden_id_estado_seq'::regclass);


--
-- Name: favorito id_favorito; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.favorito ALTER COLUMN id_favorito SET DEFAULT nextval('ecommerce.favorito_id_favorito_seq'::regclass);


--
-- Name: imagen id_imagen; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.imagen ALTER COLUMN id_imagen SET DEFAULT nextval('ecommerce.imagen_id_imagen_seq'::regclass);


--
-- Name: marca id_marca; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.marca ALTER COLUMN id_marca SET DEFAULT nextval('ecommerce.marca_id_marca_seq'::regclass);


--
-- Name: metodo_pago id_metodo_pago; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.metodo_pago ALTER COLUMN id_metodo_pago SET DEFAULT nextval('ecommerce.metodo_pago_id_metodo_pago_seq'::regclass);


--
-- Name: orden id_orden; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden ALTER COLUMN id_orden SET DEFAULT nextval('ecommerce.orden_id_orden_seq'::regclass);


--
-- Name: orden_item id_orden_item; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden_item ALTER COLUMN id_orden_item SET DEFAULT nextval('ecommerce.orden_item_id_orden_item_seq'::regclass);


--
-- Name: pago id_pago; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.pago ALTER COLUMN id_pago SET DEFAULT nextval('ecommerce.pago_id_pago_seq'::regclass);


--
-- Name: producto id_producto; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.producto ALTER COLUMN id_producto SET DEFAULT nextval('ecommerce.producto_id_producto_seq'::regclass);


--
-- Name: resena id_resena; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.resena ALTER COLUMN id_resena SET DEFAULT nextval('ecommerce.resena_id_resena_seq'::regclass);


--
-- Name: tipo_envio id_tipo_envio; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.tipo_envio ALTER COLUMN id_tipo_envio SET DEFAULT nextval('ecommerce.tipo_envio_id_tipo_envio_seq'::regclass);


--
-- Name: usuario id_usuario; Type: DEFAULT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('ecommerce.usuario_id_usuario_seq'::regclass);


--
-- Data for Name: auditoria; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.auditoria (id_auditoria, id_usuario, accion, entidad, "timestamp", detalle) FROM stdin;
1	1	INICIO	SISTEMA	2026-05-17 05:02:57.296016	Pipeline de datos ejecutado con éxito
2	2	LOGIN	USUARIO	2026-05-17 05:02:57.296016	Juan Pérez entró desde Windows 11
3	3	UPDATE	PRODUCTO	2026-05-17 05:02:57.296016	Se actualizó stock de iPhone 15 Pro Max
4	1	CREATE	CATEGORIA	2026-05-17 05:02:57.296016	Nueva categoría Accesorios añadida
5	5	LOGOUT	USUARIO	2026-05-17 05:02:57.296016	Sesión cerrada correctamente
6	7	RESET_PASSWORD	usuario	2026-05-20 22:52:11.878313	Restablecimiento de contraseña por código de recuperación
7	7	LOGIN	usuario	2026-05-20 22:52:27.842241	Inicio de sesión exitoso. Rol: empleado
8	7	LOGIN	usuario	2026-05-20 22:57:32.226138	Inicio de sesión exitoso. Rol: cliente
9	15	REGISTER	usuario	2026-05-20 22:59:46.106223	Registro inicial como PENDIENTE. Email: suarezpinto245@gmail.com
10	16	REGISTER	usuario	2026-05-20 23:09:37.678873	Registro inicial como PENDIENTE. Email: suarezpinto245@gmail.com 
11	7	LOGIN	usuario	2026-05-20 23:28:58.958982	Inicio de sesión exitoso. Rol: cliente
12	7	LOGIN	usuario	2026-05-20 23:33:16.057934	Inicio de sesión exitoso. Rol: cliente
13	7	LOGIN	usuario	2026-05-20 23:58:44.096226	Inicio de sesión exitoso. Rol: cliente
14	7	LOGIN	usuario	2026-05-21 00:06:11.931007	Inicio de sesión exitoso. Rol: cliente
15	7	LOGIN	usuario	2026-05-21 00:09:54.734076	Inicio de sesión exitoso. Rol: cliente
16	7	LOGIN	usuario	2026-05-21 07:40:55.563949	Inicio de sesión exitoso. Rol: cliente
17	7	LOGIN	usuario	2026-05-21 07:49:36.199589	Inicio de sesión exitoso. Rol: cliente
18	7	LOGIN	usuario	2026-05-21 07:57:30.875112	Inicio de sesión exitoso. Rol: cliente
19	7	LOGIN	usuario	2026-05-21 07:57:37.613935	Inicio de sesión exitoso. Rol: cliente
20	7	LOGIN	usuario	2026-05-21 08:09:59.296949	Inicio de sesión exitoso. Rol: cliente
21	7	LOGIN	usuario	2026-05-21 09:35:41.540345	Inicio de sesión exitoso. Rol: empleado
22	7	LOGIN	usuario	2026-05-21 09:38:52.628208	Inicio de sesión exitoso. Rol: empleado
\.


--
-- Data for Name: carrito; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.carrito (id_carrito, id_usuario, estado, fecha_creacion, fecha_actualizacion) FROM stdin;
1	2	ABIERTO	2026-05-17 05:02:56.970878	2026-05-17 05:02:56.970878
2	3	ABIERTO	2026-05-17 05:02:56.970878	2026-05-17 05:02:56.970878
3	4	ABIERTO	2026-05-17 05:02:56.970878	2026-05-17 05:02:56.970878
\.


--
-- Data for Name: carrito_item; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.carrito_item (id_carrito_item, id_carrito, id_producto, cantidad, precio_unitario, fecha_creacion) FROM stdin;
1	1	1	1	499.99	2026-05-17 05:02:57.033507
2	1	5	2	99.00	2026-05-17 05:02:57.033507
3	2	2	1	1199.00	2026-05-17 05:02:57.033507
\.


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.categoria (id_categoria, nombre) FROM stdin;
1	Tecnología
2	Calzado
3	Ropa
4	Deportes
5	Hogar
6	Accesorios
7	Libros
\.


--
-- Data for Name: cupon; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.cupon (id_cupon, codigo, porcentaje_descuento, activo, fecha_expiracion) FROM stdin;
1	BIENVENIDA20	20.00	t	2026-12-31
2	GRAVITY10	10.00	t	2026-06-30
3	DESCUENTONAVIDAD	50.00	f	2025-12-25
\.


--
-- Data for Name: direccion; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.direccion (id_direccion, id_usuario, direccion, ciudad, pais, latitud, longitud, fecha_creacion) FROM stdin;
1	2	Calle 100 #15-20	Bogotá	Colombia	\N	\N	2026-05-17 05:02:56.79638
2	3	Carrera 80 #45-10	Medellín	Colombia	\N	\N	2026-05-17 05:02:56.79638
3	4	Av. Paseo de la Reforma 222	CDMX	México	\N	\N	2026-05-17 05:02:56.79638
4	5	Calle Florida 500	Buenos Aires	Argentina	\N	\N	2026-05-17 05:02:56.79638
5	6	Av. Larco 123	Lima	Perú	\N	\N	2026-05-17 05:02:56.79638
\.


--
-- Data for Name: estado_orden; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.estado_orden (id_estado, nombre) FROM stdin;
1	Pendiente
2	Pago Confirmado
3	En Proceso
4	Enviado
5	Entregado
\.


--
-- Data for Name: favorito; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.favorito (id_favorito, id_usuario, id_producto, fecha_agregado) FROM stdin;
1	1	1	2026-05-17 09:46:39.387945
2	1	2	2026-05-17 09:46:39.387945
\.


--
-- Data for Name: imagen; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.imagen (id_imagen, id_producto, url, es_principal, fecha_creacion) FROM stdin;
16	19	https://images.unsplash.com/photo-1542291026-7eec264c27ff	t	2026-05-19 16:31:31.22107
8	15	https://images.unsplash.com/photo-1593359677879-a4bb92f829d1	t	2026-05-19 02:43:51.763168
9	20	https://images.unsplash.com/photo-1591488320449-011701bb6704	t	2026-05-19 02:43:51.763168
7	11	https://images.unsplash.com/photo-1517336714460-45732238469d	t	2026-05-19 02:43:51.763168
1	1	https://images.unsplash.com/photo-1606144042614-b2417e99c4e3	t	2026-05-19 02:43:51.763168
5	5	https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7	t	2026-05-19 02:43:51.763168
4	4	https://images.unsplash.com/photo-1527443224154-c4a3942d3acf	t	2026-05-19 02:43:51.763168
2	2	https://images.unsplash.com/photo-1696446701796-da61225697cc	t	2026-05-19 02:43:51.763168
6	8	https://images.unsplash.com/photo-1505740420928-5e560c06d30e	t	2026-05-19 02:43:51.763168
3	3	https://images.unsplash.com/photo-1542291026-7eec264c27ff	t	2026-05-19 02:43:51.763168
10	19	https://images.unsplash.com/photo-1542291026-7eec264c27ff	t	2026-05-19 16:29:04.99234
11	13	https://images.unsplash.com/photo-1518791841217-8f162f1e1131	t	2026-05-19 16:31:31.22107
13	16	https://images.unsplash.com/photo-1516035069371-29a1b244cc32	t	2026-05-19 16:31:31.22107
12	14	https://images.unsplash.com/photo-1558981403-c5f9899a28bc	t	2026-05-19 16:31:31.22107
14	17	https://images.unsplash.com/photo-1589739900297-a554c9870747	t	2026-05-19 16:31:31.22107
15	18	https://images.unsplash.com/photo-1545454675-8841c8d515f4	t	2026-05-19 16:31:31.22107
\.


--
-- Data for Name: marca; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.marca (id_marca, nombre) FROM stdin;
1	Sony
2	Nike
3	Samsung
4	Apple
5	Adidas
6	Logitech
7	Xiaomi
8	LG
\.


--
-- Data for Name: metodo_pago; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.metodo_pago (id_metodo_pago, nombre) FROM stdin;
1	Tarjeta de Crédito
2	Transferencia Bancaria
3	PayPal
4	Efectivo
\.


--
-- Data for Name: orden; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.orden (id_orden, id_usuario, id_direccion, id_metodo_pago, id_tipo_envio, id_estado, total, fecha_orden) FROM stdin;
1	2	1	1	1	4	499.99	2026-05-17 05:02:57.087915
2	3	2	2	2	2	1199.00	2026-05-17 05:02:57.087915
\.


--
-- Data for Name: orden_item; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.orden_item (id_orden_item, id_orden, id_producto, cantidad, precio_unitario) FROM stdin;
1	1	1	1	499.99
2	2	2	1	1199.00
\.


--
-- Data for Name: pago; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.pago (id_pago, id_orden, monto, referencia, estado, fecha) FROM stdin;
1	1	499.99	REF-001-XYZ	APROBADO	2026-05-17 05:02:57.192593
2	2	1199.00	REF-002-ABC	PENDIENTE	2026-05-17 05:02:57.192593
\.


--
-- Data for Name: producto; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.producto (id_producto, nombre, descripcion, precio, stock, sku, id_marca, estado, fecha_creacion, fecha_actualizacion) FROM stdin;
1	PlayStation 5 Slim	Consola con lector de discos 1TB	499.99	15	GA-PS5-SLIM	1	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
2	iPhone 15 Pro Max	Titanio Natural 256GB	1199.00	10	AP-IP15PM	4	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
3	Zapatillas Air Max 90	Clásico diseño urbano	130.00	45	NK-AM90-W	2	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
4	Monitor Samsung Odyssey G9	49 pulgadas Ultra Wide	1299.99	5	SA-OD-G9	3	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
5	Mouse MX Master 3S	Ergonómico para productividad	99.00	30	LO-MX3S	6	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
6	Camiseta Real Madrid 2024	Equipación oficial local	95.00	100	AD-RM24-H	5	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
7	Xiaomi 14 Ultra	Cámara Leica 512GB	999.00	12	XI-14U-BK	7	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
8	Audífonos Sony WH-1000XM5	Cancelación de ruido líder	349.00	20	SO-XM5-SL	1	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
9	Balón Adidas Al Rihla	Balón oficial FIFA	40.00	60	AD-BAL-FIFA	5	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
10	Teclado Logitech G915	Mecánico inalámbrico RGB	229.00	18	LO-G915-BR	6	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
11	MacBook Air M3	13 pulgadas, 8GB RAM	1099.00	8	AP-MBA-M3	4	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
12	Samsung Galaxy S24 Ultra	Pantalla plana 120Hz	1299.00	15	SA-S24-ULT	3	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
13	Nike Tech Fleece	Sudadera con capucha negra	110.00	40	NK-TF-HD	2	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
14	Apple Watch Ultra 2	GPS + Celular 49mm	799.00	25	AP-AW-U2	4	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
15	LG C3 OLED TV	55 pulgadas 4K Smart TV	1499.00	7	LG-C3-55	8	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
16	Cámara Sony A7 IV	Mirrorless Full Frame	2499.00	4	SO-A7IV-B	1	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
17	Xiaomi Pad 6	Tablet 144Hz 256GB	399.00	20	XI-PAD6-GR	7	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
18	Barra de Sonido Sony A5000	5.1.2 canales Dolby Atmos	799.00	10	SO-HT-A5000	1	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
19	Zapatillas Nike Dunk Low	Panda colorway blanco y negro	115.00	50	NK-DUNK-PND	2	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
20	SSD Samsung 990 Pro 2TB	NVMe Gen4 ultra rápido	180.00	100	SA-990P-2TB	3	DISPONIBLE	2026-05-17 05:02:56.857291	2026-05-17 05:02:56.857291
\.


--
-- Data for Name: producto_categoria; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.producto_categoria (id_producto, id_categoria) FROM stdin;
1	1
2	1
3	2
4	1
5	1
6	3
7	1
8	1
9	4
10	1
11	1
12	1
13	3
14	1
15	1
16	1
17	1
18	1
19	2
20	1
\.


--
-- Data for Name: resena; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.resena (id_resena, id_usuario, id_producto, comentario, puntuacion, fecha_creacion) FROM stdin;
1	2	1	Increíble consola, llegó muy rápido	5	2026-05-17 05:02:57.244257
2	3	2	El teléfono es genial pero muy caro	4	2026-05-17 05:02:57.244257
\.


--
-- Data for Name: tipo_envio; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.tipo_envio (id_tipo_envio, nombre) FROM stdin;
1	Estándar (3-5 días)
2	Express (24h)
3	Recogida en Punto Físico
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.usuario (id_usuario, nombre, email, password_hash, rol, estado, telefono, fecha_creacion, fecha_actualizacion, sms_code, sms_expires_at) FROM stdin;
1	Rubi Suarez	rubi@gravitytech.com	admin_secure_2026	admin	ACTIVO	+573001234567	2026-05-17 05:02:56.744336	2026-05-17 05:02:56.744336	\N	\N
2	Juan Perez	juan.perez@gmail.com	user_hash_101	cliente	ACTIVO	+573101112222	2026-05-17 05:02:56.744336	2026-05-17 05:02:56.744336	\N	\N
3	Maria Casas	maria.casas@outlook.com	user_hash_102	cliente	ACTIVO	+573203334444	2026-05-17 05:02:56.744336	2026-05-17 05:02:56.744336	\N	\N
4	Roberto Guia	roberto.guia@yahoo.com	user_hash_103	cliente	ACTIVO	+573155556666	2026-05-17 05:02:56.744336	2026-05-17 05:02:56.744336	\N	\N
5	Elena Vargas	elena.vargas@mail.com	user_hash_104	cliente	ACTIVO	+573127778888	2026-05-17 05:02:56.744336	2026-05-17 05:02:56.744336	\N	\N
6	Soporte Tecnico	soporte@tienda.com	user_hash_105	empleado	ACTIVO	+573009990000	2026-05-17 05:02:56.744336	2026-05-17 05:02:56.744336	\N	\N
16	 Ernetito 	suarezpinto245@gmail.com 	$2b$12$iyfs5pKT0ie4yduJ6P82NuibYd3rQra.5jsejoGwEp94pV1avsQXO	cliente	PENDIENTE	3123597564	2026-05-20 23:09:37.671189	2026-05-20 23:09:37.671189	764175	2026-05-20 23:14:37.67
7	Rubi	rubisuarezpinto@gmail.com	$2b$12$LFi69S/YFbxwLKfsCPaNIeEwmemeqKEACr0sxF1nJleHAqaYgxxf6	empleado	ACTIVO	3123598797	2026-05-18 15:13:42.711154	2026-05-18 15:13:42.711154	\N	\N
9	Bartolito	jhoanaraque3@gmail.com	$2b$12$6SNLu4lj01rl7psJ2kV3h.PXTbnwhBZEIHH0aILiuFshs.zIauEWq	cliente	PENDIENTE	3123598797	2026-05-20 08:59:42.739043	2026-05-20 08:59:42.739043	200307	2026-05-20 09:06:56.859
15	Ernetito	suarezpinto245@gmail.com	$2b$12$epL.8W2C1DK7SQCjXvFDO.1RVI6X5e8WER6l68hZSs1OeLXCb96Ji	cliente	PENDIENTE	3123598465	2026-05-20 22:59:46.093474	2026-05-20 22:59:46.093474	329624	2026-05-20 23:04:46.092
\.


--
-- Data for Name: usuario_metodo_pago; Type: TABLE DATA; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

COPY ecommerce.usuario_metodo_pago (id_usuario, id_metodo_pago, estado, fecha_creacion) FROM stdin;
2	1	ACTIVO	2026-05-17 05:02:56.853773
3	2	ACTIVO	2026-05-17 05:02:56.853773
4	3	ACTIVO	2026-05-17 05:02:56.853773
\.


--
-- Name: auditoria_id_auditoria_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.auditoria_id_auditoria_seq', 22, true);


--
-- Name: carrito_id_carrito_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.carrito_id_carrito_seq', 3, true);


--
-- Name: carrito_item_id_carrito_item_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.carrito_item_id_carrito_item_seq', 3, true);


--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.categoria_id_categoria_seq', 7, true);


--
-- Name: cupon_id_cupon_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.cupon_id_cupon_seq', 3, true);


--
-- Name: direccion_id_direccion_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.direccion_id_direccion_seq', 5, true);


--
-- Name: estado_orden_id_estado_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.estado_orden_id_estado_seq', 5, true);


--
-- Name: favorito_id_favorito_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.favorito_id_favorito_seq', 2, true);


--
-- Name: imagen_id_imagen_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.imagen_id_imagen_seq', 16, true);


--
-- Name: marca_id_marca_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.marca_id_marca_seq', 8, true);


--
-- Name: metodo_pago_id_metodo_pago_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.metodo_pago_id_metodo_pago_seq', 4, true);


--
-- Name: orden_id_orden_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.orden_id_orden_seq', 2, true);


--
-- Name: orden_item_id_orden_item_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.orden_item_id_orden_item_seq', 2, true);


--
-- Name: pago_id_pago_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.pago_id_pago_seq', 2, true);


--
-- Name: producto_id_producto_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.producto_id_producto_seq', 21, true);


--
-- Name: resena_id_resena_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.resena_id_resena_seq', 2, true);


--
-- Name: tipo_envio_id_tipo_envio_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.tipo_envio_id_tipo_envio_seq', 3, true);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

SELECT pg_catalog.setval('ecommerce.usuario_id_usuario_seq', 16, true);


--
-- Name: auditoria auditoria_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.auditoria
    ADD CONSTRAINT auditoria_pkey PRIMARY KEY (id_auditoria);


--
-- Name: carrito_item carrito_item_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.carrito_item
    ADD CONSTRAINT carrito_item_pkey PRIMARY KEY (id_carrito_item);


--
-- Name: carrito carrito_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.carrito
    ADD CONSTRAINT carrito_pkey PRIMARY KEY (id_carrito);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_categoria);


--
-- Name: cupon cupon_codigo_key; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.cupon
    ADD CONSTRAINT cupon_codigo_key UNIQUE (codigo);


--
-- Name: cupon cupon_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.cupon
    ADD CONSTRAINT cupon_pkey PRIMARY KEY (id_cupon);


--
-- Name: direccion direccion_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.direccion
    ADD CONSTRAINT direccion_pkey PRIMARY KEY (id_direccion);


--
-- Name: estado_orden estado_orden_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.estado_orden
    ADD CONSTRAINT estado_orden_pkey PRIMARY KEY (id_estado);


--
-- Name: favorito favorito_id_usuario_id_producto_key; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.favorito
    ADD CONSTRAINT favorito_id_usuario_id_producto_key UNIQUE (id_usuario, id_producto);


--
-- Name: favorito favorito_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.favorito
    ADD CONSTRAINT favorito_pkey PRIMARY KEY (id_favorito);


--
-- Name: imagen imagen_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.imagen
    ADD CONSTRAINT imagen_pkey PRIMARY KEY (id_imagen);


--
-- Name: marca marca_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.marca
    ADD CONSTRAINT marca_pkey PRIMARY KEY (id_marca);


--
-- Name: metodo_pago metodo_pago_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.metodo_pago
    ADD CONSTRAINT metodo_pago_pkey PRIMARY KEY (id_metodo_pago);


--
-- Name: orden_item orden_item_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden_item
    ADD CONSTRAINT orden_item_pkey PRIMARY KEY (id_orden_item);


--
-- Name: orden orden_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden
    ADD CONSTRAINT orden_pkey PRIMARY KEY (id_orden);


--
-- Name: pago pago_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (id_pago);


--
-- Name: producto_categoria producto_categoria_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.producto_categoria
    ADD CONSTRAINT producto_categoria_pkey PRIMARY KEY (id_producto, id_categoria);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_producto);


--
-- Name: producto producto_sku_key; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.producto
    ADD CONSTRAINT producto_sku_key UNIQUE (sku);


--
-- Name: resena resena_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.resena
    ADD CONSTRAINT resena_pkey PRIMARY KEY (id_resena);


--
-- Name: tipo_envio tipo_envio_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.tipo_envio
    ADD CONSTRAINT tipo_envio_pkey PRIMARY KEY (id_tipo_envio);


--
-- Name: carrito_item uq_carrito_item_carrito_producto; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.carrito_item
    ADD CONSTRAINT uq_carrito_item_carrito_producto UNIQUE (id_carrito, id_producto);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario_metodo_pago usuario_metodo_pago_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.usuario_metodo_pago
    ADD CONSTRAINT usuario_metodo_pago_pkey PRIMARY KEY (id_usuario, id_metodo_pago);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: auditoria fk_auditoria_usuario; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.auditoria
    ADD CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: carrito fk_carrito_usuario; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.carrito
    ADD CONSTRAINT fk_carrito_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: carrito_item fk_ci_carrito; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.carrito_item
    ADD CONSTRAINT fk_ci_carrito FOREIGN KEY (id_carrito) REFERENCES ecommerce.carrito(id_carrito) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: carrito_item fk_ci_producto; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.carrito_item
    ADD CONSTRAINT fk_ci_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: direccion fk_direccion_usuario; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.direccion
    ADD CONSTRAINT fk_direccion_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: favorito fk_favorito_producto; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.favorito
    ADD CONSTRAINT fk_favorito_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: favorito fk_favorito_usuario; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.favorito
    ADD CONSTRAINT fk_favorito_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: imagen fk_imagen_producto; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.imagen
    ADD CONSTRAINT fk_imagen_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orden_item fk_oi_orden; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden_item
    ADD CONSTRAINT fk_oi_orden FOREIGN KEY (id_orden) REFERENCES ecommerce.orden(id_orden) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orden_item fk_oi_producto; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden_item
    ADD CONSTRAINT fk_oi_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden fk_orden_direccion; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden
    ADD CONSTRAINT fk_orden_direccion FOREIGN KEY (id_direccion) REFERENCES ecommerce.direccion(id_direccion) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden fk_orden_estado; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden
    ADD CONSTRAINT fk_orden_estado FOREIGN KEY (id_estado) REFERENCES ecommerce.estado_orden(id_estado) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden fk_orden_metodopago; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden
    ADD CONSTRAINT fk_orden_metodopago FOREIGN KEY (id_metodo_pago) REFERENCES ecommerce.metodo_pago(id_metodo_pago) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden fk_orden_tipoenvio; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden
    ADD CONSTRAINT fk_orden_tipoenvio FOREIGN KEY (id_tipo_envio) REFERENCES ecommerce.tipo_envio(id_tipo_envio) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden fk_orden_usuario; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.orden
    ADD CONSTRAINT fk_orden_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pago fk_pago_orden; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.pago
    ADD CONSTRAINT fk_pago_orden FOREIGN KEY (id_orden) REFERENCES ecommerce.orden(id_orden) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: producto_categoria fk_pc_categoria; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.producto_categoria
    ADD CONSTRAINT fk_pc_categoria FOREIGN KEY (id_categoria) REFERENCES ecommerce.categoria(id_categoria) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: producto_categoria fk_pc_producto; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.producto_categoria
    ADD CONSTRAINT fk_pc_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: producto fk_producto_marca; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.producto
    ADD CONSTRAINT fk_producto_marca FOREIGN KEY (id_marca) REFERENCES ecommerce.marca(id_marca) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: resena fk_resena_producto; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.resena
    ADD CONSTRAINT fk_resena_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resena fk_resena_usuario; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.resena
    ADD CONSTRAINT fk_resena_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: usuario_metodo_pago fk_ump_metodopago; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.usuario_metodo_pago
    ADD CONSTRAINT fk_ump_metodopago FOREIGN KEY (id_metodo_pago) REFERENCES ecommerce.metodo_pago(id_metodo_pago) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: usuario_metodo_pago fk_ump_usuario; Type: FK CONSTRAINT; Schema: ecommerce; Owner: ecommerce_admin_rubi
--

ALTER TABLE ONLY ecommerce.usuario_metodo_pago
    ADD CONSTRAINT fk_ump_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TABLE cupon; Type: ACL; Schema: ecommerce; Owner: postgres
--

GRANT ALL ON TABLE ecommerce.cupon TO ecommerce_admin_rubi;


--
-- Name: SEQUENCE cupon_id_cupon_seq; Type: ACL; Schema: ecommerce; Owner: postgres
--

GRANT ALL ON SEQUENCE ecommerce.cupon_id_cupon_seq TO ecommerce_admin_rubi;


--
-- Name: TABLE favorito; Type: ACL; Schema: ecommerce; Owner: postgres
--

GRANT ALL ON TABLE ecommerce.favorito TO ecommerce_admin_rubi;


--
-- Name: SEQUENCE favorito_id_favorito_seq; Type: ACL; Schema: ecommerce; Owner: postgres
--

GRANT ALL ON SEQUENCE ecommerce.favorito_id_favorito_seq TO ecommerce_admin_rubi;


--
-- Name: TABLE imagen; Type: ACL; Schema: ecommerce; Owner: postgres
--

GRANT ALL ON TABLE ecommerce.imagen TO ecommerce_admin_rubi;


--
-- Name: SEQUENCE imagen_id_imagen_seq; Type: ACL; Schema: ecommerce; Owner: postgres
--

GRANT ALL ON SEQUENCE ecommerce.imagen_id_imagen_seq TO ecommerce_admin_rubi;


--
-- PostgreSQL database dump complete
--

\unrestrict jva2XkwGPkjcuHyza2TGqGlzGWKoLf8ucDodongkoq6gh6ncYlSgE5YTy90Lb6g

