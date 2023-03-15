
--displays each employee name, salary and max salary.
SELECT  e.*, MAX(Salary) over() as max_salary
	FROM public.employee e;
	
--displays each employee name, salary, max salary group by dept	
SELECT e.*, MAX(salary) OVER(partition by emp_dept) as max_salary
	FROM public.employee e; 
	
--asign a unique number to eah employee
SELECT e.*,
	row_number() over()
FROM public.employee e; 

-- asing a unique numbe and group them by dept, and order by dept
SELECT e.*,
	row_number() over(partition by emp_dept order by emp_dept)
FROM public.employee e; 


--Fetch the first two record from each emp_dept
	
SELECT * FROM (
	SELECT e.*,
		row_number() over(partition by emp_dept order by emp_dept) as row_numb
	FROM public.employee e
 ) x
 WHERE x.row_numb <3;
 
 
 -- Fetch the top 3 emp. from each dept earning the max salery;
SELECT * FROM (
	SELECT e.*,
	RANK() OVER(partition by emp_dept order by salary desc) rank
	FROM public.employee e ) x
WHERE x.rank <4;
 
