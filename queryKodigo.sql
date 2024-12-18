/*Para ello debemos crear la base de datos con la siguiente información:*/
CREATE TABLE proveedores (id_proveedor INT auto_increment PRIMARY KEY, nombre VARCHAR(255) NOT NULL, telefono VARCHAR(20));
CREATE TABLE categorias (id_categoria INT auto_increment primary KEY, nombre VARCHAR(255) NOT NULL);
CREATE TABLE productos (id_producto INT auto_increment primary KEY, nombre VARCHAR(255) NOT NULL, precio DECIMAL(10,2) NOT NULL, cantidad INT NOT NULL, id_categoria INT NOT NULL, id_proveedor INT NOT NULL, FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria), foreign key (id_proveedor) REFERENCES proveedores(id_proveedor));

/*Insertar datos en las tablas, por lo menos 5 categorías, 5 proveedores y 10 productos*/
INSERT INTO proveedores (nombre, telefono) VALUES ('Proveedor A','2527-0000'),('Proveedor B','2528-0000'),('Proveedor C','2529-0000'),('Proveedor D','2530-0000'),('Proveedor E','2531-0000');
INSERT INTO categorias (nombre) VALUES ('Electrónicos'),('Ropa'),('Alimentos'),('Muebles'),('Juguetes');
INSERT INTO productos (nombre, precio, cantidad, id_categoria, id_proveedor) VALUES 
('Laptop HP', 950.00, 8, 1, 1),
('Teléfono celular marca Samsung', 250.00, 16, 1, 2),
('Teléfono celular marca Iphone 15 Pro', 1450.00, 4, 1, 3),
('Sandalias marca Vans', 90.00, 75, 2, 4),
('Blusa Nautica cuello V', 135.00, 10, 2, 4),
('Jeans marca Oscar de la Renta', 40.00, 38, 2, 4),
('Cereal Kellogs', 3.99, 168, 3, 5),
('Sofa de cuero 2 plazas', 879.99, 3, 4, 5),
('Cama ergonomica ortopedica', 1200.00, 4, 4, 5),
('Consola PlayStation 5', 750.00, 11, 5, 5);

/*Obtener todos los productos con su respectivo proveedor (detallar la información del proveedor)*/
SELECT p.id_producto, p.nombre, p.precio, p.cantidad, pr.nombre as nombreproveedor, pr.telefono as telefonoproveedor FROM productos as p join proveedores as pr on p.id_proveedor=pr.id_proveedor;
/*Mostrar solo los productos cuyo precio sea mayor a 15.00*/
SELECT p.id_producto, p.nombre, p.precio, p.cantidad FROM productos as p where precio > 15;
/*Editamos un proveedor para quitarle el telefono*/
UPDATE proveedores SET telefono=NULL where id_proveedor=2;
/*Listar los proveedores que no tienen teléfono registrado.*/
SELECT pr.id_proveedor, pr.nombre, pr.telefono FROM proveedores as pr where telefono is null;
/*Contar cuántos productos hay por proveedor.*/
SELECT count(p.id_producto) as cantidad, pr.nombre FROM productos as p join proveedores as pr on p.id_proveedor=pr.id_proveedor group by pr.nombre;
/*Calcular el valor total del inventario (cantidad * precio) para cada producto.*/
SELECT p.nombre, p.cantidad, p.precio, (p.cantidad*p.precio) as total FROM productos as p;
/*Obtener el proveedor con más productos registrados.*/
SELECT sum(p.cantidad) as suma, pr.nombre as nombreproveedor FROM productos as p join proveedores as pr on p.id_proveedor=pr.id_proveedor group by pr.nombre order by suma desc limit 1;
/*Obtener el número total de productos por cada categoría. Usa la cláusula GROUP BY para agrupar los resultados por categoría.*/
SELECT count(p.id_producto) as cantidad, c.nombre FROM productos as p join categorias as c on p.id_categoria=c.id_categoria group by c.nombre;
/*Asignar una clasificación a los productos basándote en su precio: "Alto" para productos con un precio mayor a 20.00, y "Bajo" para los demás. Utiliza la cláusula CASE.*/
SELECT p.nombre, CASE WHEN (p.precio>20) then 'Alto' else 'Bajo'end as clasificacion FROM productos as p;
/*Creamos 2 proveedores nuevos sin asociarlos a ningun productos*/
INSERT INTO proveedores (nombre, telefono) VALUES 
('Proveedor F', '2561-0000'),
('Proveedor G', '2562-0000');
/*Obtener todos los productos junto con el nombre del proveedor, incluso si algunos proveedores no tienen productos asociados. Usa la cláusula LEFT JOIN.*/
SELECT p.nombre, p.precio, p.cantidad, pr.nombre as nombreproveedor FROM proveedores AS pr LEFT JOIN productos AS p on pr.id_proveedor=p.id_proveedor;
/*Calcular el precio promedio de los productos en cada categoría. Usa la cláusula GROUP BY para agrupar los productos por categoría.*/
SELECT c.id_categoria, c.nombre AS nombre_categoria, 
AVG(p.precio) AS precio_promedio
FROM categorias c
JOIN productos p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre;
/*Filtrar las categorías que tienen más de dos productos registrados. Utiliza la cláusula HAVING para aplicar una condición de agregación.*/
SELECT c.id_categoria, c.nombre AS nombrecategoria, COUNT(p.id_producto) AS total FROM categorias as c join productos as p on c.id_categoria=p.id_categoria group by c.id_categoria,c.nombre having count(p.id_producto) >2;
/*Aumentar en un 10% el precio de todos los productos de la categoría "Electrónica" u otra categoría.*/
UPDATE productos AS p JOIN categorias as c ON p.id_categoria=c.id_categoria SET p.precio=p.precio*1.10 where c.nombre = 'Electrónicos';
/*Probamos la actualización*/
SELECT * FROM productos AS p JOIN categorias as c ON p.id_categoria=c.id_categoria where c.nombre = 'Electrónicos';
/*Obtener el producto más caro de cada categoría. Utiliza una subconsulta en la cláusula WHERE para obtener el máximo precio por categoría.*/
SELECT p1.nombre, p1.precio, c.nombre as nombrecategoria FROM productos as p1 JOIN categorias as c on p1.id_categoria=c.id_categoria where p1.precio=(SELECT max(p2.precio) as total FROM productos as p2 where p1.id_categoria=p2.id_categoria);
/*Verificar si hay proveedores que tienen productos cuyo precio es menor a 10.00. Utiliza la cláusula EXISTS con una subconsulta.*/
SELECT c.nombre, p.* FROM productos AS p JOIN categorias as c ON p.id_categoria=c.id_categoria;

SELECT pr.id_proveedor, pr.nombre FROM proveedores as pr where exists(SELECT 1 FROM productos as p where pr.id_proveedor=p.id_proveedor and p.precio <10);
