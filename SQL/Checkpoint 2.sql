use Teste;

select * from locacao.cliente;
select * from locacao.categoria;
select * from locacao.classificacao;
select * from locacao.filme;

update locacao.filme
set cd_classificacao = 1
where sg_categoria = 'F' or sg_categoria = 'C';

update locacao.filme
set cd_classificacao = 2
where sg_categoria = 'D' or sg_categoria = 'T';

update locacao.filme
set cd_classificacao = 3
where sg_categoria = 'S';

select nm_filme, sg_categoria, cd_classificacao from locacao.filme
order by cd_classificacao;

select cd_classificacao, count (*) from locacao.filme
group by cd_classificacao
order by cd_classificacao;

select distinct cd_classificacao from locacao.filme

select f.cd_classificacao, count (*), c.nm_classificacao, c.vl_locacao_diaria
from locacao.filme as f, locacao.categoria as c
where f.cd_classificacao = c.cd_classificacao
group by f.cd_classificacao
order by f.cd_classificacao;

select * from locacao.classificacao;

--cd do filme, 
--nome do filme, 
--nome da classificação, 
--valor do emprestimos, 
--nome da categoria

-- o uso do "as" é para dar nomes temporários as tabelas e ficar mais fácil de puxar elas

select cd_filme from locacao.filme
select nm_filme from locacao.filme
select cd_classificacao from locacao.filme
select vl_locacao_diaria from locacao.classificacao
select nm_categoria from locacao.categoria

select f.cd_filme, f.nm_filme, f.cd_classificacao, c.vl_locacao_diaria, ct.nm_categoria
from locacao.filme as f, locacao.classificacao as c, locacao.categoria as ct
where f.cd_classificacao = c.cd_classificacao and f.sg_categoria = ct.sg_categoria --where é a condição e envolve mais de uma tabela
order by f.cd_classificacao;

--quantas solicitações cada cliente fez?

select s.cd_cliente, count (*) as qt_solicitacao
from locacao.solicitacao as s
group by s.cd_cliente

--nome do cliente que solicitou

select s.cd_cliente,l.nm_cliente ,l.cd_cliente, count (*) as qt_solicitacao
from locacao.solicitacao as s, locacao.cliente as l
where s.cd_cliente = l.cd_cliente
group by s.cd_cliente, l.cd_cliente, l.nm_cliente

--dados da solicitação, 
--dados do filme, 
--dados do cliente

select s.cd_cliente, c.nm_cliente, s.dt_solicitacao,
	   f.nm_filme, sf.dt_devolucao_prevista, sf.dt_devolucao_real

from locacao.cliente as c, locacao.solicitacao as s,
	 locacao.filme as f, locacao.solicitacao_filme as sf

where s.cd_cliente = c.cd_cliente and
	  s.cd_cliente = sf.cd_solicitacao and
	  sf.cd_filme = f.cd_filme

order by s.cd_solicitacao;

--nome do cliente que solicitou

select s.cd_cliente, c.nm_cliente, s.dt_solicitacao,
	   f.nm_filme, sf.dt_devolucao_prevista, sf.dt_devolucao_real

from locacao.cliente as c, locacao.solicitacao as s,
	 locacao.filme as f, locacao.solicitacao_filme as sf

where s.cd_cliente = 3 and
	  s.cd_cliente = c.cd_cliente and
	  s.cd_cliente = sf.cd_solicitacao and
	  sf.cd_filme = f.cd_filme

order by s.cd_solicitacao;

--totalizou cada uma das solicitações 

select sf.cd_solicitacao , sum(c.vl_locacao_diaria) as total

from locacao.classificacao as c, locacao.filme as f, locacao.solicitacao as s,
	 locacao.solicitacao_filme as sf

where s.cd_solicitacao = sf.cd_solicitacao and
	  sf.cd_filme = f.cd_filme and
	  f.cd_classificacao = c.cd_classificacao

group by sf.cd_solicitacao

--having sum(c.vl_locacao_diaria)

order by sf.cd_solicitacao;

--quanto tempo que o cliente ficou com cada filme (DATEDIFF ( datepart , startdate , enddate ) datepart, nesse caso, day)
select s.cd_solicitacao, sf.cd_filme, datediff(day, s.dt_solicitacao, dt_devolucao_real) as dias
from locacao.solicitacao as s, locacao.solicitacao_filme as sf
where sf.cd_solicitacao = s.cd_solicitacao--faz com que as duas tabelas se conversem
order by s.cd_solicitacao;