SET datestyle = "ISO, DMY";

create table pais (
	idPais serial primary key,
	nomePais varchar(40) NOT NULL,
	numClubes int NOT NULL
);

create table participantes (
	numAssociado serial primary key,
	nome varchar(100) NOT NULL,
	endereco varchar(200) NOT NULL,
	telefone bigint NOT NULL,
	idPais int,
	FOREIGN KEY (idPais) REFERENCES pais (idPais) ON DELETE CASCADE ON UPDATE CASCADE
);

create table campeonato (
	idCampeonato serial primary key NOT NULL,
	nomeCamp varchar(100),
	numAssociado int,
	tipoParticipante varchar(20) NOT NULL,
	FOREIGN KEY (numAssociado) REFERENCES participantes (numAssociado) ON DELETE CASCADE ON UPDATE CASCADE
);

create table jogador (
	numAssociado int primary key,
	nivel varchar(20) NOT NULL,
	FOREIGN KEY (numAssociado) REFERENCES participantes (numAssociado) ON DELETE CASCADE ON UPDATE CASCADE
);

create table hotel (
	nomeHotel varchar(100) primary key NOT NULL,
	telefone bigint NOT NULL,
	endereco varchar(200) NOT NULL
);

create table salao (
	idSalao serial primary key,
	nomeHotel varchar(100) NOT NULL,
	capacidade int NOT NULL,
	FOREIGN KEY (nomeHotel) REFERENCES hotel (nomeHotel) ON DELETE CASCADE ON UPDATE CASCADE
);

create table salao_meios (
	idSalao int,
	meios varchar(100) NOT NULL,
	FOREIGN KEY (idSalao) REFERENCES salao (idSalao) ON DELETE CASCADE ON UPDATE CASCADE
);

create table jogo (
	idJogo serial primary key,
	numArbitro int,
	idSalao int, 
	ingressos int NOT NULL,
	dataJogo date,
	FOREIGN KEY (numArbitro) REFERENCES participantes (numAssociado) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (idSalao) REFERENCES salao (idSalao) ON DELETE CASCADE ON UPDATE CASCADE
);

create table movimentos (
	idJogo int,
	idMov serial primary key,
	posJogada varchar(10) NOT NULL,
	comentario varchar(100) NOT NULL,
	FOREIGN KEY (idJogo) REFERENCES jogo (idJogo) ON DELETE CASCADE ON UPDATE CASCADE
);

create table jogam (
	idJogo int,
	numJogador int,
	cor varchar(7) NOT NULL,
	FOREIGN KEY (idJogo) REFERENCES jogo (idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (numJogador) REFERENCES participantes (numAssociado) ON DELETE CASCADE ON UPDATE CASCADE
);

create table IF NOT EXISTS acomodam_se (
	nomeHotel varchar(100) NOT NULL,
	numAssociado int,
	dataEntrada varchar(15) NOT NULL,
	dataSaida varchar(15) NOT NULL,
	CONSTRAINT limite PRIMARY KEY (nomeHotel, numAssociado),
	FOREIGN KEY (nomeHotel) REFERENCES hotel (nomeHotel) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (numAssociado) REFERENCES participantes (numAssociado) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Função que verifica se um jogador consta como árbitro no pŕoprio jogo
-- Se retorna NULL a operação INSERT/UPDATE é abortada
-- Se retorna NEW a operação INSERT/UPDATE é completada
CREATE OR REPLACE FUNCTION eh_arbitro()
RETURNS TRIGGER AS $$
DECLARE resultado BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT * FROM jogo WHERE numArbitro = NEW.numJogador AND idjogo = NEW.idJogo) INTO resultado;
	IF resultado THEN
		RAISE EXCEPTION 'Jogador consta como árbitro no próprio jogo.';
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que é disparada para cada registro antes de um INSERT ou UPDATE na tabela jogam.
-- Garante a restrição de que um árbitro não pode ser um jogador no mesmo jogo que arbitra.
CREATE TRIGGER restricao_arbitro
BEFORE INSERT OR UPDATE ON jogam
FOR EACH ROW
EXECUTE FUNCTION eh_arbitro();

-- Trigger que é disparada para cada registro antes de um INSERT ou UPDATE na tabela jogam.
-- Garante a restrição de que um jogador não seja arbitrado por um árbitro de mesma nacionalidade.
CREATE OR REPLACE FUNCTION arbitro_nacionalidade()
RETURNS TRIGGER AS $$
DECLARE paisJogador INTEGER;
DECLARE paisArbitro INTEGER;
BEGIN
	SELECT idpais INTO paisJogador 
	FROM participantes 
	WHERE NEW.numjogador = numassociado;
	SELECT idpais INTO paisArbitro 
	FROM jogo JOIN participantes ON numarbitro = numassociado
	WHERE NEW.idjogo = idjogo;
	IF paisJogador = paisArbitro THEN
		RAISE EXCEPTION 'O jogador é da mesma nacionalidade do árbitro para o jogo atribuido.';
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que é disparada para cada registro antes de um INSERT ou UPDATE
CREATE TRIGGER restricao_arbitro_nacionalidade
BEFORE INSERT OR UPDATE ON jogam
FOR EACH ROW
EXECUTE FUNCTION arbitro_nacionalidade();

-- INSERTS - População do Database
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'Brasil', 3);
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'Alemanha', 4);
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'Chile', 2);
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'Argentina', 3);
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'Canadá', 3);
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'Estados Unidos da América', 5);
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'França', 2);
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'China', 10);
INSERT INTO public.pais(nomepais, numclubes) VALUES ( 'Japão', 6);

INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Giovana Fernandes Barros', 'Rua Lavras, 1283, Belo Horizonte-MG, 30330-010', 3145119286, 1);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Isabella Goncalves Pereira', 'Rua Otávio Tarquino de Souza, 902, Belo Horizonte-MG, 31842-400', 3120778376, 1);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Samuel Melo Rodrigues', 'Travessa Rosalvo Carvalho Silva, 1157, Salvador-BA, 41253-400', 7120659250, 1);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Maximilian Keller', 'eeperbahn 62, 88427 Bad Schussenried', 0376007720, 2);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Thorsten Nagel', 'Schillerstrasse 68, 82278 Althegnenberg', 08202468547, 2);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Barbara Kunze', 'Koepenicker Str. 30, 56355 Oberbachheim', 06776120189, 2);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Susanne Fuerst', 'Amsinckstrasse 92, 91807 Lichtenberg', 0359559033, 2);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Monique Aranda Alba', 'Baltasar Brum 7323, 90601 La Escobilla', 91122921, 3);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Martina Espinoza Barreto', 'Joaquin Suarez 6323, 90700 Santa Lucía', 93207450, 3);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Johana Centeno Montoya', 'Larrañaga 4806, 90200 Las Piedras', 9879206, 4);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Tadeo Montoya Oquendo', 'Acuña de Figeroa 6942, 20303 Playa Verde', 93451552, 4);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Cristo Tórrez Anaya', 'Brisas 6450, 15104 Marindia', 97117422, 4);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Diane Tinney', '1035 Heritage Drive, Calgary, AB T2V 2W2', 763537651, 5);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Jane Bostick', '3018 Jasper Ave, Edmonton, AB T5J 3N6', 7809058185, 5);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Deborah Howard', '4276 Scotts Lane, Cobble Hill, BC V0R 1L1', 751355496, 5);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Andre Menendez', '1801 Smith Road, Tucker, GA 30084', 674107417, 6);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Wanda Gartner', '2134 Bassel Street, Morgan City, LA 70380', 434217852, 6);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Sherry Phelps', '2291 Hillcrest Circle, Minneapolis, MN 55411', 468069612, 6);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Joann Holt', '4736 Centennial Farm Road, Dow City, IA 51528', 482223579, 6);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Jan Howard', '2976 Private Lane, Albany, GA 31701', 671222839, 6);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Keith Glasper', '389 Simpson Avenue, Steelton, PA 17113', 205629741, 6);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Francis Champagne', '66, Rue du Limas, 97100 BASSE-TERRE', 188127164805526, 7);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Millard Ouellet', '97, Rue de Strasbourg, 63000 CLERMONT-FERRAND', 168104671827013, 7);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Lei Ho', '99, Stadiou Street, 7715 Lageia', 95273792, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Guang Kung', '155, Makri Street, 8726 Miliou', 96340147, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Qiang Lei', '298, Karageorgi Servias Street, 2648 Moni Agiou Irakleidiou', 22691205, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Bao Chia', '240, Trianton Avenue, 8748 Fyti', 26260675, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Hui Ho', '178, Theotokopoulou Str., 6300 Larnaka', 24197625, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Qiang Peng', '150, Eleftheriou Venizelou str, 2961 Pachyammos', 96205755, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Yuan Tsai', '86, Syngrou Avenue, 8878 Livad', 26265148, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Ai Tsai', '170, Akti Pagalou, 2043 Strovolos', 22847605, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Fang Yin Liang', '273, Souniou Ave., 4000 Mesa Geitonia', 97190650, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Wang Yu', '196, Thisseos Avenue, 2365 Agios Dometios', 96966884, 8);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Bao Ko', '284, Marathonos Street, 2233 Latsia (Lakkia)', 96768618, 9);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('An She', '47, Papanastasiou Street, 2480 Tseri', 22225116, 9);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Wei Lo', '296, Xanthou Street, 2312 Lakatameia', 22600084, 9);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Shu Fang Shao', '76, Akti Pagalou, 2055 Strovolos', 22650350, 9);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Park Lo', '54, Moatsou Street, 7624 Tremetousia', 99462689, 9);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Lien Hu', '160, Kastrinoyannaki Str., 1480 Nicosia', 96332696, 9);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Bob Fisher', '2586 Gerald L. Bates Drive, Quincy, MA 02169', 6177707093, 6);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Boris Sparski', 'Rathausstrasse 90, 90706 Fürth', 0911779168, 6);
INSERT INTO public.participantes(nome, endereco, telefone, idpais) VALUES ('Garry Kasparov', '36, cours Franklin Roosevelt, 13009 MARSEILLE', 0444847898, 2);

INSERT INTO public.hotel(nomeHotel, telefone, endereco) VALUES ('Hilton', 5133533860, '4013 Gnatty Creek Road, Huntington, NY 11743');
INSERT INTO public.hotel(nomeHotel, telefone, endereco) VALUES ('Matsoud Plaza', 202920054, '4735 5th Avenue, Berwyn, AB T0H 0E0');
INSERT INTO public.hotel(nomeHotel, telefone, endereco) VALUES ('Ibis Consolação', 1125869523, 'Avenida Paulista 2355, Bela Vista, 01311300 SAO PAULO');

INSERT INTO public.salao(nomeHotel, capacidade) VALUES ('Hilton', 100);
INSERT INTO public.salao(nomeHotel, capacidade) VALUES ('Hilton', 120);
INSERT INTO public.salao(nomeHotel, capacidade) VALUES ('Matsoud Plaza', 95);
INSERT INTO public.salao(nomeHotel, capacidade) VALUES ('Matsoud Plaza', 110);
INSERT INTO public.salao(nomeHotel, capacidade) VALUES ('Ibis Consolação', 200);
INSERT INTO public.salao(nomeHotel, capacidade) VALUES ('Ibis Consolação', 340);

INSERT INTO public.salao_meios(idsalao, meios) VALUES (1, 'Televisão');
INSERT INTO public.salao_meios(idsalao, meios) VALUES (1, 'Projetor');
INSERT INTO public.salao_meios(idsalao, meios) VALUES (2, 'Monitores');
INSERT INTO public.salao_meios(idsalao, meios) VALUES (3, 'Televisão');
INSERT INTO public.salao_meios(idsalao, meios) VALUES (4, 'Projetor');
INSERT INTO public.salao_meios(idsalao, meios) VALUES (5, 'Televisão');
INSERT INTO public.salao_meios(idsalao, meios) VALUES (5, 'Monitores');
INSERT INTO public.salao_meios(idsalao, meios) VALUES (6, 'Projetor');

INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('Intercomp', 1, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('Intercomp', 2, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('Intercomp', 3, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('Intercomp', 4, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('Intercomp', 5, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('Intercomp', 6, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('Intercomp', 7, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 8, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 9, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 10, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 11, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 12, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 13, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 14, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 15, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 16, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 17, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 18, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('LUE', 19, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 20, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 21, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 22, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 23, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 24, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 25, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 26, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 27, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 28, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 29, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 30, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 31, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 32, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 33, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 34, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 35, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 36, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 37, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 38, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 39, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 40, 'jogador');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 41, 'árbitro');
INSERT INTO public.campeonato(nomecamp, numassociado, tipoparticipante) VALUES ('BIFE', 42, 'jogador');

INSERT INTO public.jogador(numassociado, nivel) VALUES (1, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (2, 'mediano');
INSERT INTO public.jogador(numassociado, nivel) VALUES (4, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (6, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (8, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (9, 'mediano');
INSERT INTO public.jogador(numassociado, nivel) VALUES (11, 'iniciante');
INSERT INTO public.jogador(numassociado, nivel) VALUES (13, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (14, 'mediano');
INSERT INTO public.jogador(numassociado, nivel) VALUES (16, 'iniciante');
INSERT INTO public.jogador(numassociado, nivel) VALUES (17, 'mediano');
INSERT INTO public.jogador(numassociado, nivel) VALUES (19, 'iniciante');
INSERT INTO public.jogador(numassociado, nivel) VALUES (20, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (22, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (23, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (25, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (26, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (28, 'mediano');
INSERT INTO public.jogador(numassociado, nivel) VALUES (29, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (30, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (32, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (33, 'mediano');
INSERT INTO public.jogador(numassociado, nivel) VALUES (35, 'iniciante');
INSERT INTO public.jogador(numassociado, nivel) VALUES (36, 'expert');
INSERT INTO public.jogador(numassociado, nivel) VALUES (38, 'mediano');
INSERT INTO public.jogador(numassociado, nivel) VALUES (39, 'iniciante');
INSERT INTO public.jogador(numassociado, nivel) VALUES (40, 'mediano');
INSERT INTO public.jogador(numassociado, nivel) VALUES (42, 'iniciante');

INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 1, '01/06/2023', '08/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 2, '02/06/2023', '09/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 3, '01/06/2023', '10/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 4, '03/06/2023', '10/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 5, '02/06/2023', '10/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 6, '04/06/2023', '10/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 7, '01/06/2023', '10/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 8, '01/06/2023', '11/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 9, '02/06/2023', '08/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 10, '02/06/2023', '08/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 11, '01/06/2023', '07/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 12, '03/06/2023', '07/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 13, '01/06/2023', '07/06/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Ibis Consolação', 14, '02/06/2023', '09/06/2023');

INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 15, '10/09/2023', '20/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 16, '11/09/2023', '19/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 17, '10/09/2023', '20/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 18, '10/09/2023', '20/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 19, '09/09/2023', '21/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 20, '09/09/2023', '21/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 21, '08/09/2023', '21/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 22, '11/09/2023', '22/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 23, '12/09/2023', '17/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 24, '11/09/2023', '18/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 25, '10/09/2023', '18/09/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Matsoud Plaza', 26, '11/09/2023', '20/09/2023');

INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 27, '18/01/2023', '25/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 28, '18/01/2023', '26/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 29, '20/01/2023', '26/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 30, '21/01/2023', '26/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 31, '18/01/2023', '26/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 32, '18/01/2023', '24/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 33, '17/01/2023', '25/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 34, '17/01/2023', '25/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 35, '17/01/2023', '22/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 36, '18/01/2023', '26/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 37, '19/01/2023', '26/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 38, '18/01/2023', '25/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 39, '19/01/2023', '24/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 40, '19/01/2023', '23/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 41, '20/01/2023', '25/01/2023');
INSERT INTO public.acomodam_se(nomeHotel, numassociado, dataentrada, datasaida) VALUES ('Hilton', 42, '21/01/2023', '25/01/2023');

INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (3, 5, 90, '04/06/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (3, 6, 100, '05/06/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (12, 5, 90, '05/06/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (12, 6, 100, '06/06/2023');

INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (15, 3, 95, '13/09/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (15, 4, 90, '14/09/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (24, 3, 90, '14/09/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (24, 4, 85, '15/09/2023');

INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (27, 1, 90, '20/01/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (27, 2, 80, '21/01/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (41, 1, 85, '21/01/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (41, 2, 75, '22/01/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (31, 1, 70, '19/01/2023');
INSERT INTO public.jogo(numarbitro, idsalao, ingressos, datajogo) VALUES (31, 2, 95, '20/01/2023');


INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (1, 4, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (1, 8, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (2, 6, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (2, 11, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (3, 1, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (3, 7, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (4, 2, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (4, 8, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (5, 16, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (5, 22, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (6, 17, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (6, 25, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (7, 23, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (7, 21, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (8, 22, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (8, 17, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (9, 42, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (9, 35, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (10, 36, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (10, 42, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (11, 39, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (11, 30, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (12, 38, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (12, 28, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (13, 40, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (13, 35, 'brancas');

INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (14, 36, 'pretas');
INSERT INTO public.jogam(idjogo, numjogador, cor) VALUES (14, 40, 'brancas');

INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (2, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'não', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (10, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (7, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'atacou o rei');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (8, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (5, 'sim', 'capturou um bisco');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (12, 'não', 'capturou um peão');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (9, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (4, 'não', 'capturou um cavalo');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'capturou uma torre');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (1, 'sim', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (11, 'não', 'capturou a rainha');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (6, 'não', 'xeque-mate');
INSERT INTO public.movimentos (idjogo, posjogada, comentario) VALUES (3, 'sim', 'capturou a rainha');