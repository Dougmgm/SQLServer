use Teste;

create schema locacao;

create table locacao.cliente(
	cd_cliente int primary key identity(1,1),
	nm_cliente varchar(50) not null
);

create table locacao.classificacao(
	cd_classificacao int primary key identity(1,1),
	vl_locacao_diaria money not null
);

create table locacao.categoria(
	sg_categoria char(1) primary key,
	nm_categoria varchar(30) not null
);

create table locacao.solicitacao(
	cd_solicitacao int primary key identity(1,1),
	cd_cliente int not null,
	dt_solicitacao date not null

	foreign key(cd_cliente) references locacao.cliente(cd_cliente)
	on delete cascade
	on update cascade
);

create table locacao.filme(
	cd_filme int primary key identity(1,1),
	nm_filme varchar(50) not null,
	sg_categoria char(1),
	cd_classificacao int,

	foreign key(sg_categoria) references locacao.categoria(sg_categoria)
	on delete set null
	on update cascade,

	foreign key(cd_classificacao) references locacao.classificacao(cd_classificacao)
	on delete set null
	on update cascade
);

create table locacao.solicitacao_filme(
	cd_filme int not null,
	cd_solicitacao int not null,
	dt_devolucao_prevista date not null,
	dt_devolucao_real date,

	primary key(cd_filme, cd_solicitacao),

	foreign key(cd_filme) references locacao.filme(cd_filme)
	on delete cascade
	on update cascade,

	foreign key(cd_solicitacao) references locacao.solicitacao(cd_solicitacao)
	on delete cascade
	on update cascade
);

begin transaction;

insert into locacao.categoria (sg_categoria, nm_categoria)
values ('D', 'Drama'), ('T', 'Terror'), ('S', 'Suspense'), ('C', 'Comédia'), ('R', 'Romântico');

commit;

insert into locacao.categoria (sg_categoria, nm_categoria)
values ('F', 'Ficção');

select * from locacao.classificacao;
select * from locacao.categoria;

alter table locacao.classificacao
add nm_classificacao varchar(30) not null;

begin transaction;

insert into locacao.cliente(nm_cliente)
values ('Gustavo Tanamati'), ('Kauan Muriel'), ('Douglas Menchon'), ('André Lopes'), ('Salsicha');

commit;

select * from locacao.cliente;

select * from locacao.classificacao; --teste

insert into locacao.classificacao(vl_locacao_diaria)
values (1), (2), (3), (4), (5);

-- teste
commit;

select * from locacao.classificacao;


begin transaction;
insert into locacao.filme(nm_filme, sg_categoria)
values ('Aliens','S'), ('Clube da Luta','T'), ('Operação Leva Jato','C'), ('Onze mulheres e nenhum segredo', 'C'), ('Ilha do Medo', 'T')
commit;

insert into locacao.filme(cd_classificacao)
values ('dezoito'), ('dezesseis'), ('livre'), ('dez'), ('quatorze')
commit;


select * from locacao.filme;

begin transaction;
insert into locacao.solicitacao(cd_cliente, dt_solicitacao) 
values(2, '20220228'), (5, '20220212'), (3, '20221212'), (1, '20221104'), (4, '20220104'),
	  (1, '20220611'), (5, '20220208'), (3, '20221003'), (2, '20220728'), (4, '20221115')
commit;
select * from locacao.solicitacao;

begin transaction;
insert into locacao.solicitacao_filme(cd_filme, cd_solicitacao, dt_devolucao_prevista, dt_devolucao_real) 
values(1, 10, '20220212', '20220228'), (1, 2, '20220212', '20220228'), (5, 1, '20220212', '20220228'), (4, 5, '20220212', '20220228'),
      (2, 2, '20220212', '20220228'), (2, 1, '20220212', '20220228'), (4, 9, '20220212', '20220228'), (4, 4, '20220212', '20220228'),
	  (3, 3, '20220212', '20220228'), (3, 8, '20220212', '20220228'), (3, 1, '20220212', '20220228'), (3, 2, '20220212', '20220228'),
	  (4, 8, '20220212', '20220228'), (4, 10, '20220212', '20220228'), (2, 7, '20220212', '20220228'), (2, 5, '20220212', '20220228'),
	  (5, 5, '20220212', '20220228'), (5, 10, '20220212', '20220228'), (1, 6, '20220212', '20220228'), (1, 1, '20220212', '20220228')
commit;
select * from locacao.solicitacao_filme;

/*
--5 Cliente
--5 Filmes
--10 Solicitações
--20 Solicitação_Filmes
begin transaction;

insert into locacao.classificacao(vl_locacao_diaria)
'20223011'
10.00
10.15
*/