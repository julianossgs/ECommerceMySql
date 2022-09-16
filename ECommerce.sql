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

#criando tabela nf_itens
create table nf_itens(
num_nota int not null,
id_produto int not null,
qtd int not null,
val_unit decimal(10,2) not null,
desconto decimal(10,2) not null,
total decimal(10,2) not null

);

#criando FK na tab nf_itens ref tab nota_fiscal
alter table nf_itens
add constraint fk_nf_itens_nota_fiscal foreign key(num_nota)
references nota_fiscal(num_nota);

#criando FK na tab nf_itens ref tab produto
alter table nf_itens
add constraint fk_nf_itens_produto foreign key(id_produto)
references produto(id_produto);

#criando tabela nf_obs
create table nf_obs(
num_nota int not null,
obs varchar(255) not null

);

#criando FK na tab nf_obs ref tab nota_fiscal
alter table nf_obs
add constraint fk_nf_obs_nota_fiscal foreign key(num_nota)
references nota_fiscal(num_nota);

#criando tabela carrinho_compras
create table carrinho_compras(
sessao varchar(32) not null,
id_produto int not null,
qtd int not null,
val_unit decimal(10,2) not null,
desconto decimal(10,2) not null,
total decimal(10,2) not null,
data_hora_sessa datetime not null
);

#criando FK na tab carrinho_compras ref tab produtos
alter table carrinho_compras
add constraint fk_carrinho_produto foreign key(id_produto)
references produto(id_produto);

#criando index na tabela carrinho_compras
create index ix_cc_1 on carrinho_compras(sessao);

#criando tabela rastreabilidade
create table rastreabilidade(
num_pedido int not null,
status_ped char(1) not null,
#A=aguard aprov , S=Separacao , F=faturado , T=em transito , E=entregue
data_hora datetime not null,
id_user varchar(50)
);

#criando FK na tab rastreabilidade ref tab pedidos
alter table rastreabilidade
add constraint fk_rast_pedidos foreign key(num_pedido)
references pedidos(num_pedido);

#Carga das tabelas
insert into categorias (descricao)
values('JOGOS'),('ELETRÔNICOS'),('SOM'),('ELETRODOMÉSTICOS');

select * from categorias;

insert into fabricantes(nome_fabricante)
values('FABR JOGOS'),('FABR ELETR.'),('FABR. SOM'),('FABR ELE.DOMES');

select * from fabricantes;

#carga unidade federal
insert into unidade_federal(cod_uf,uf,nome_uf)
select * from curso.uf;

select * from unidade_federal;

#carga tabela cidades
insert into cidades(nome_cidade,cod_mun,cod_uf)
select a.nome_mun,
       a.cod_mun,
       a.cod_uf
       from curso.senso a
       where ano = '2014';
       
 #carga tabela clientes
 insert into clientes(nome,sobrenome,email,senha,data_nasc,data_cadastro,
 ult_acesso,ult_compra,situacao)
 values('Maria','Santos','maria@gmail.com',md5(1234),'1990-02-08',
 now(),now(),now(),'A');
 
 insert into clientes(nome,sobrenome,email,senha,data_nasc,data_cadastro,
 ult_acesso,ult_compra,situacao)
 values('João','Lima','joao@gmail.com',md5(4321),'1991-09-08',
 now(),now(),now(),'A');
 
 select * from clientes;
 
 #carga tabela cliente_endereco
 insert into cliente_endereco(id_cliente,tipo,endereco,numero,bairro,cep,id_cidade)
 values(1,'P','Rua A','123','Da luz','00000000','49'),
       (2,'P','Rua B','321','Barreiro','00000000','50');
       
 select * from cliente_endereco;    
 
 #carga tabela cond_pagto
 insert into cond_pagto(descricao,tipo) values('A vista','B');
 insert into cond_pagto(descricao,tipo) values('A vista','D');
 insert into cond_pagto(descricao,tipo) values('10 x','C');
 insert into cond_pagto(descricao,tipo) values('5 x','C');
 insert into cond_pagto(descricao,tipo) values('3 x','C');
 
 describe cond_pagto;
 select * from cond_pagto;
 
 #carga tabela cond_pagto_det
 insert into cond_pagto_det values(1,1,100,1);
 
 insert into cond_pagto_det values(2,1,100,1);
 
 insert into cond_pagto_det values(3,1,10,30);
 insert into cond_pagto_det values(3,2,10,60);
 insert into cond_pagto_det values(3,3,10,90);
 insert into cond_pagto_det values(3,4,10,120);
 insert into cond_pagto_det values(3,5,10,150);
 insert into cond_pagto_det values(3,6,10,180);
 insert into cond_pagto_det values(3,7,10,210);
 insert into cond_pagto_det values(3,8,10,240);
 insert into cond_pagto_det values(3,9,10,270);
 insert into cond_pagto_det values(3,10,10,300);
 
 insert into cond_pagto_det values(4,1,20,30);
 insert into cond_pagto_det values(4,2,20,60);
 insert into cond_pagto_det values(4,3,20,90);
 insert into cond_pagto_det values(4,4,20,120);
 insert into cond_pagto_det values(4,5,20,150);
 
 insert into cond_pagto_det values(5,1,33.33,30);
 insert into cond_pagto_det values(5,2,33.33,60);
 insert into cond_pagto_det values(5,3,33.34,90);
 
 select * from cond_pagto_det;
 
 #carga tabela produto
 insert into produto(descricao,id_categoria,id_fabricante,preco_custo,preco_venda)
 values
 ('Jogo Infantil',1,1,50,200),
 ('Jogo Acao',1,1,50,200),
 ('Jogo Estratégia',1,1,50,200),
 ('Smart TV 42',2,2,1300,2000),
 ('Notbook 15',2,2,2200,3000),
 ('SmartPhone',2,2,550,1200),
 ('Caixa de som BOOM',3,3,750,1500),
 ('Som Automotivo',3,3,250,500),
 ('Sound MIX',3,3,750,1200),
 ('Geladeira',4,4,780,1580),
 ('Batedeira',4,4,200,450),
 ('Aspirador de Pó',4,4,200,4500);
 
 select * from produto;
 
 #carga tabela estoque
 insert into estoque(id_produto,estoque_total,estoque_livre,estoque_reservado)
 values('1','100','100','0'),('2','100','100','0'),('3','100','100','0'),
       ('4','100','100','0'),('5','100','100','0'),('6','100','100','0'),
       ('7','100','100','0'),('8','100','100','0'),('9','100','100','0'),
       ('10','100','100','0'),('11','100','100','0'),('12','100','100','0');
       
 
 #Trigger que atualiza o status do pedido na tabela rastreabilidade
 delimiter //
 create trigger Tgr_insert_status_ped after insert
 on pedidos
 for each row
 begin
 insert into rastreabilidade values(new.num_pedido,new.status_ped,now(),user());
 end//
 delimiter ;
 
 #Trigger
 delimiter //
 create trigger Tgr_update_status_ped after update
 on pedidos
 for each row
 begin
 insert into rastreabilidade values(new.num_pedido,new.status_ped,now(),user());
 end//
 delimiter ;
 
 
 #Procedure p/ inserir itens no carrinho
 delimiter //
 create procedure proc_carga_carrinho(v_sessao varchar(32),
									  v_id_prod int,
                                      v_qtd int,
                                      out resposta varchar(50))
  main: begin
        declare v_qtd_livre int;
        declare v_preco_venda decimal(10,2);
        declare cod_erro char(5) default '00000';
        declare msg TEXT;
        declare rows int;
        declare continue handler for sqlexception
        BEGIN
        get diagnostics condition 1
        cod_erro = returned_sqlstate,msg = message_text;
        end;
        
        #lendo qtd no estoque e atribuindo a variável
        select estoque_Livre into v_qtd_livre from estoque
        where id_produto = v_id_prod;
        
        select v_qtd_livre
        #verificando se existe saldo diponivel
        if v_qtd > v_qtd_livre then
        set resposta = 'Quantidade indisponivel';
        leave main;
        end if;
        
        #pegando preço de venda
        select preco_venda into v_preco_venda from produto
        where id_produto = v_id_prod;
        #carga no carrinho de compras
        #inicia transação
        start transaction;
        #carregando carrinhos
        insert into carrinho_compras values
        (md5(v_sessao),v_id_prod,v_qtd,v_preco_venda,0,v_qtd * v_preco_venda,now());
        
        #atualizando disponibilidade estoque
        update estoque set estoque_livre = estoque_livre - v_qtd,
						   estoque_reservado = estoque_reservado + v_qtd
                           where id_produto = v_id_prod;
                           
        #checando excessao com if
        if cod_erro = '00000' then
        get diagnostics rows = ROW_COUNT;
        set resposta = concat('Atualizacao com sucesso = ',rows);
        commit;
        
        else
        set resposta = concat('Erro na atualizacao,error = ',cod_erro,
        ', message = ',msg);
        rollback;
        end if;
        end//
        
 
 delimiter ;
 
 #Procedure p/ fechar carrinho de compras
 delimiter //
 create procedure proc_fechar_carrinho(v_sessao varchar(32),
                                       v_id_cliente int,
                                       v_id_pagto int,
                                       v_frete decimal(10,2),
                                       v_ender char(1), #P=principal A=alternativo
                                       out resposta varchar(255))
 main: begin
	   declare v_total_ped decimal(10,2);
       declare v_total_desc decimal(10,2);
       declare v_num_ped int;
       declare v_id_endereco int;
       declare cod_erro char(5) default '00000';
       declare msg TEXT;
       declare rows int;
       declare continue handler for sqlexception
       BEGIN
       get diagnostics condition 1
       cod_erro = returned_sqlstate,msg = MESSAGE_TEXT;
       end;
       
       #Pegando total carrinho e atribuindo a variável
       select sum(total)as tot,sum(desconto) as descto into v_total_ped,v_total_desc
       from carrinho_compras
       where sessao = MD5(v_sessao);
       
       #pegando preço de venda
       select id_endereco into v_id_endereco from cliente_endereco
       where id_cliente = v_id_cliente limit 1;
       
       #iniciando transação
       start transaction;
       
       insert into pedidos
       (id_cliente,id_endereco,id_pagto,total_prod,total_frete,total_desc,
        total_pedido,data_pedido,status_ped)
        values(v_id_cliente,v_id_endereco,v_id_pagto,v_total_ped,v_frete,
        v_total_desc,((v_total_ped + v_frete)- v_total_desc),now(),'A');
        
        
       #pegando id do pedido
       set v_num_ped = last_insert_id();
       
       #inserindo pedido itens
       insert into pedido_itens
       (num_pedido,id_produto,qtd,val_unit,desconto,total)
       select v_num_ped,id_produto,qtd,val_unit,desconto,total
       from carrinho_compras
       where sessao = md5(v_sessao);
       
       #eliminando itens do carrinho
       delete from carrinho_compras
       where sessao = md5(v_sessao);
       
       #checando excessão co  IF
       
       if cod_erro = '00000' then
          get diagnostics rows = ROW_COUNT;
          set resposta = concat('Atualizacao com sucesso =  ',rows);
          commit;
	   else
          set resposta = concat('Erro na atualização,error = ',rows,cod_erro,
          ', message = ',msg);
          rollback;
       end if;   
                                    
 end//
 delimiter ;
 
 
 #Procedure Fatura de Pedido
 delimiter //
 create procedure proc_fat_pedido(v_num_ped int,
								  out resposta varchar(255))
  main:begin
       declare cod_erro char(5) default '00000';
       declare msg TEXT;
       declare v_num_nf int;
       declare v_qtd int;
       declare v_id_prod int;
       declare rows int;
       declare exit handler for sqlexception
       BEGIN
       get diagnostics condition 1 @sqlstate = RETURNED_SQLSTATE,
       @nroerro = MYSQL_ERRNO, @msgerro = MESSAGE_TEXT;
       set @msg_erro_completa = concat("ERRO: ",@nroerro, " (", @sqlstate, "): ", @msgerro);
       select @msg_erro_completa;
       END;
       
       if(select count(*) from pedidos where num_pedido = v_num_ped and
          status_ped in ('F','T','E')) > 0 then
          set resposta = 'Pedido já faturado';
          leave main;
          end if;
          
          #inicia a transação
          start transaction;
          #lendo pedido e inserindo nfe
          insert into nota_fiscal(num_ped_ref,id_cliente,id_endereco,id_pagto,
          total_prod,total_frete,total_desc,total_nf,data_nf,status_nf,id_user)
          select num_pedido,id_cliente,id_endereco,id_pagto,total_prod,total_frete,
				 total_desc,total_pedido,now(),'N',user()
          from pedidos
          where num_pedido = v_num_ped;
          
          #pegando numero da nfe
          set v_num_nf = last_insert_id();
          
          #lendo pedido itens e inserindo nota itens
          insert into nf_itens
          (num_nota,id_produto,qtd,val_unit,desconto,total)
          select v_num_nf,id_produto,qtd,val_unit,desconto,total
          from pedido_itens
          where num_pedido = v_num_ped;
          
          #Atualizando status ped
          update pedidos set status_ped = 'F'
          where num_pedido = v_num_ped;
          
          #Atualizando estoque
          update estoque inner join
          pedido_itens on estoque.id_produto = pedido_itens.id_produto
          set
          estoque.estoque_total = estoque.estoque_total - pedido_itens,qtd,
          estoque.estoque_reservado = estoque.estoque_reservado - pedido_itens.qtd
          where
          pedido_itens.num_pedido = v_num_ped;
          
          #checando excessao com IF
          
          if cod_erro = '00000' then
          get diagnostics rows = ROW_COUNT;
          set resposta = concat('Atualizacao com Sucesso = ',rows);
          commit;
          else
          set resposta = concat('Erro na atualizacao,error = '.rows,cod_erro,',
           message = ',msg);
           rollback;
           end if;
           
           select concat('resposta ',resposta)
           union all
           select concat('cod_erro ',cod_erro);
           END//
          
          
                                  
  delimiter ;    
  
  #View Visão Financeira
  
  create view v_financeiro
  as
  select a.num_nota,
         a.id_cliente,
         d.nome,
         a.id_pagto,
         b.descricao,
         b.tipo,
         a.total_nf,
         a.data_nf,
         c.parcela,
         c.percentual,
         c.dias,
         cast(a.total_nf / 100 * c.percentual as decimal(10,2)) valor_parcela,
         cast(date_add(a.data_nf,interval c.dias day) as date) vencimento
         from nota_fiscal a
         inner join cond_pagto b
         on a.id_pagto = b.id_pagto
         inner join cond_pagto_det c
         on a.id_pagto = b.id_pagto
         and a.id_pagto = c.id_pagto
         inner join clientes d
         on a.id_cliente = d.id_cliente
         where a.status_nf = 'N';
  
  
  select * from v_financeiro;
  
 