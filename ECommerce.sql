create database mini_ec;
use mini_ec;
#cadastros independentes

#Usuarios
create table usuarios(
id_user int not null primary key auto_increment,
nome_user varchar(50) not null,
email_user varchar(60) not null,
senha varchar(32) not null,
data_cadastro datetime not null,
status enum('A','B') #A=ativo B=bloqueado
);

#criando unique indice no campo email(integridade e performance)
create unique index ix_usr_1 on usuarios(email_user);

#tabela de categorias
create table categorias(
id_categoria int not null primary key auto_increment,
descricao varchar(50) not null
);

#tabela fabricantes
create table fabricantes(
id_fabricante int not null primary key auto_increment,
nome_fabricante varchar(50) not null
);

#tabela unidade federal
create table unidade_federal(
cod_uf tinyint not null primary key,
uf char(2) not null,
nome_uf varchar(50) not null
);

#tabela cidades
create table cidades(
id_cidade int not null primary key not null auto_increment,
nome_cidade varchar(70) not null,
cod_mun char(7) not null,
cod_uf tinyint(2) not null
);

#criando FK na tabela cidade
alter table cidades
add constraint fk_cid_1 foreign key(cod_uf)
references unidade_federal(cod_uf);

#criando tabela produto
create table produto(
id_produto integer not null auto_increment primary key,
descricao varchar(100) not null,
id_categoria int not null,
id_fabricante int not null,
preco_custo decimal(10,2),
preco_venda decimal(10,2)

);

#criando FK na tabela produto com ref a tabela categorias
alter table produto
add constraint fk_prod_cat foreign key(id_categoria)
references categorias(id_categoria);

#criando FK na tabela produto com ref a tabela fabricantes
alter table produto
add constraint fk_prod_fab foreign key(id_fabricante)
references fabricantes(id_fabricante);

#criando tabela produto caracteristica
create table produto_caracter(
id_produto int not null,
caracteristica varchar(50) not null,
valor varchar(50) not null
);

#criando FK na tabela produto_caracter ref a tabela produto
alter table produto_caracter
add constraint fk_prod_caract_prod foreign key(id_produto)
references produto(id_produto);

#criando tabela estoque
create table estoque(
id_produto int not null,
estoque_total int not null,
estoque_livre int,
estoque_reservado int
);

#criando FK na tabela estoque ref a tabela produto
alter table estoque
add constraint fk_estoque_prod foreign key(id_produto)
references produto(id_produto);

#criando tabela clientes
create table clientes(
id_cliente int primary key auto_increment not null,
nome varchar(32) not null,
sobrenome varchar(32) not null,
email varchar(60) not null,
senha varchar(32) not null,
data_nasc date not null,
data_cadastro datetime not null,
ult_acesso datetime,
ult_compra datetime,
situacao enum('A','B') not null
);

#criando tabela cliente_endereco
create table cliente_endereco(
id_endereco int not null primary key auto_increment,
id_cliente int not null,
tipo enum('P','A') not null, #P=principal A=alternativo
endereco varchar(60) not null,
numero varchar(10) not null,
bairro varchar(30) not null,
cep varchar(8) not null,
id_cidade int not null
);

#criando FK na tab cliente_endereco ref tab cliente
alter table cliente_endereco
add constraint fk_cli_end_cli foreign key(id_cliente)
references clientes(id_cliente);

#criando FK na tab cliente_endereco ref tab cidades
alter table cliente_endereco
add constraint fk_cli_end_cid foreign key(id_cidade)
references cidades(id_cidade);

#criando tabela cond_pagto
create table cond_pagto(
id_pagto int not null primary key auto_increment,
descricao varchar(50) not null,
tipo enum('C','D','B') not null
#C=cartao, D=debito, B=boleto
);

#criando tabela cond_pagto_det
create table cond_pagto_det(
id_pagto int not null,
parcela int not null,
percentual decimal(10,2),
dias int not null
);

#criando FK na tab cond_pagto_det ref tab cond_pagto
alter table cond_pagto_det
add constraint fk_cond_pagto_det_cond_pagto foreign key(id_pagto)
references cond_pagto(id_pagto);

#criando tabela pedidos
create table pedidos(
num_pedido int not null primary key auto_increment,
id_cliente int not null,
id_endereco int not null,
id_pagto int not null,
total_prod decimal(10,2),
total_frete decimal(10,2),
total_desc decimal(10,2),
total_pedido decimal(10,2),
data_pedido datetime not null,
previsao_entrega date,
efetiva_entrega date,
status_ped enum('A','S','F','T','E')
#A=aguard aprov , S=Separacao , F=Faturado , T=Transito, E=entregue
);

#criando FK na tab pedidos ref tab clientes
alter table pedidos
add constraint fk_pedido_cliente foreign key(id_cliente)
references clientes(id_cliente);

#criando FK na tab pedidos ref tab cliente_endereco
alter table pedidos
add constraint fk_pedido_cliente_end foreign key(id_endereco)
references cliente_endereco(id_endereco);

#criando FK na tab pedidos ref tab cond_pagto
alter table pedidos
add constraint fk_pedido_cond_pagto foreign key(id_pagto)
references cond_pagto(id_pagto);

#criando tabela pedido_itens
create table pedido_itens(
num_pedido int not null,
id_produto int not null,
qtd int not null,
val_unit decimal(10,2),
desconto decimal(10,2),
total decimal(10,2)
);

#criando FK na tab pedido_itens ref tab pedidos
alter table pedido_itens
add constraint fk_pedido_itens_pedido foreign key(num_pedido)
references pedidos(num_pedido);

#criando FK na tab pedido_itens ref tab produto
alter table pedido_itens
add constraint fk_pedido_itens_produto foreign key(id_produto)
references produto(id_produto);

#criando tabela pedido_obs
create table pedido_obs(
num_pedido int not null,
obs varchar(255) not null
);

#criando FK na tab pedido_obs ref tab pedidos
alter table pedido_obs
add constraint fk_pedido_obs_pedidos foreign key(num_pedido)
references pedidos(num_pedido);

#criando tabela nota_fiscal
create table nota_fiscal(
num_nota int not null primary key auto_increment,
num_ped_ref int not null,
id_cliente int not null,
id_endereco int not null,
id_pagto int not null,
total_prod decimal(10,2),
total_frete decimal(10,2),
total_desc decimal(10,2),
total_nf decimal(10,2),
data_nf datetime not null,
status_nf enum('N','C','D'),#N=Normal, C=Cancelada, D=Devolvida
id_user varchar(50)
);

#criando FK na tab nota_fiscal ref tab pedidos
alter table nota_fiscal
add constraint fk_nota_fiscal_pedidos foreign key(num_ped_ref)
references pedidos(num_pedido);

#criando FK na tab nota_fiscal ref tab clientes
alter table nota_fiscal
add constraint fk_nota_fiscal_clientes foreign key(id_cliente)
references clientes(id_cliente);

#criando FK na tab nota_fiscal ref cliente_endereco
alter table nota_fiscal
add constraint fk_nota_fiscal_cli_end foreign key(id_endereco)
references cliente_endereco(id_endereco);

#criando FK na tab nota_fiscal ref tab cond_pagto_det
alter table nota_fiscal
add constraint fk_nota_fiscal_cond_pagto_det foreign key(id_pagto)
references cond_pagto_det(id_pagto);