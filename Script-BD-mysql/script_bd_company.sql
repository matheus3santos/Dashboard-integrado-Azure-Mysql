create schema if not exists azure_company;
use azure_company;

select * from information_schema.table_constraints
	where constraint_schema = 'azure_company';

-- restrição atribuida a um domínio
-- create domain D_num as int check(D_num> 0 and D_num< 21);

-- 1. Criação da tabela employee
CREATE TABLE employee(
	Fname varchar(15) not null,
    Minit char(1),  -- Ajustado para char(1)
    Lname varchar(15) not null,
    Ssn char(9) not null, 
    Bdate date,
    Address varchar(30),
    Sex char(1),  -- Ajustado para char(1)
    Salary decimal(10,2),
    Super_ssn char(9),
    Dno int not null default 1,  -- Dno agora tem um valor padrão 1
    constraint chk_salary_employee check (Salary > 2000.0),
    constraint pk_employee primary key (Ssn)
);

-- 2. Criar relacionamento de supervisor com a própria tabela employee
ALTER TABLE employee 
	ADD CONSTRAINT fk_employee 
	FOREIGN KEY(Super_ssn) REFERENCES employee(Ssn)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- 3. Descrição da tabela employee
DESC employee;

-- 4. Criação da tabela departament
CREATE TABLE departament(
	Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_ssn char(9) not null,
    Mgr_start_date date, 
    Dept_create_date date,
    constraint chk_date_dept check (Dept_create_date < Mgr_start_date),  -- Verificar ordem das datas
    constraint pk_dept primary key (Dnumber),
    constraint unique_name_dept unique(Dname),
    foreign key (Mgr_ssn) references employee(Ssn) -- Relacionamento com employee
    ON UPDATE CASCADE
);

-- 5. Descrição da tabela departament
DESC departament;

-- 6. Criação da tabela dept_locations
CREATE TABLE dept_locations(
	Dnumber int not null,
	Dlocation varchar(15) not null,
    constraint pk_dept_locations primary key (Dnumber, Dlocation),
    constraint fk_dept_locations foreign key (Dnumber) references departament (Dnumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- 7. Criação da tabela project
CREATE TABLE project(
	Pname varchar(15) not null,
	Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    primary key (Pnumber),
    constraint unique_project unique (Pname),
    constraint fk_project foreign key (Dnum) references departament(Dnumber)
    ON UPDATE CASCADE
);

-- 8. Criação da tabela works_on
CREATE TABLE works_on(
	Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Essn, Pno),
    constraint fk_employee_works_on foreign key (Essn) references employee(Ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    constraint fk_project_works_on foreign key (Pno) references project(Pnumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- 9. Criação da tabela dependent
CREATE TABLE dependent(
	Essn char(9) not null,
    Dependent_name varchar(15) not null,
    Sex char(1),  -- Ajustado para char(1)
    Bdate date,
    Relationship varchar(8),
    primary key (Essn, Dependent_name),
    constraint fk_dependent foreign key (Essn) references employee(Ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- 10. Mostrar todas as tabelas criadas
SHOW TABLES;

-- 11. Descrição da tabela dependent
DESC dependent;
