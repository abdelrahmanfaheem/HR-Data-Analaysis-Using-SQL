 

 selecT *from Absenteeism_at_work

 -- Find the Healthiest That not Dring Or Smoke

-- Ration of the healthiest employees to all employees,
SELECT  
     COUNT(*) *1.0 / (SELECT COUNT(*) FROM Absenteeism_at_work) AS Healthiest_to_All_Employee_Ratio
FROM 
    Absenteeism_at_work
WHERE
    Social_drinker = 0 
    AND 
    Social_smoker = 0
    AND
    Body_mass_index < 26;

--- Get the Distrbution of the Resons
Select 
	r.Reason , 
	count (r.Reason) Count_resons
from Absenteeism_at_work a inner join Reasons r
on 
	a.Reason_for_absence=r.Number
group by
	r.Reason
order by 
	Count_resons desc

-- Top Resons for People that have an Body_mass_index >26
Select 
	r.Reason , 
	count (r.Reason) Count_resons
from Absenteeism_at_work a inner join Reasons r
on 
	a.Reason_for_absence=r.Number
where 
	a.Body_mass_index >26
group by
	r.Reason
order by 
	Count_resons desc

-- Top Resons for People that   Social_smoker=1
Select 
	r.Reason , 
	count (r.Reason) Count_resons
from Absenteeism_at_work a inner join Reasons r
on 
	a.Reason_for_absence=r.Number
where 
	a.Social_smoker=1
group by
	r.Reason
order by 
	Count_resons desc


-- Divide age in Bucket
 With age_Bucket as (
 SELECT
        CASE
            WHEN age BETWEEN 18 AND 25 THEN '18-25'
            WHEN age BETWEEN 26 AND 35 THEN '26-35'
            WHEN age BETWEEN 36 AND 45 THEN '36-45'
            WHEN age BETWEEN 46 AND 55 THEN '46-55'
            WHEN age BETWEEN 56 AND 65 THEN '56-65'
            ELSE '65+'
        END AS age_bucket
    FROM
        Absenteeism_at_work
		)
Select 
	age_bucket , 
	COUNT (*)as Count_distrbution
from	
	age_Bucket
group by 
	age_bucket
order by 
	COUNT (*) desc
	

-- Age that have Most Smoker 

With Smoker_dis as (
Select
	case 
	when age  between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 45 then '36-45'
	when age between 46 and 55 then '46-55'
	when age between 56 and 65 then '56-65'
	else '65'
	end as Age
from 
	Absenteeism_at_work
where
	Social_smoker =1
)
Select
	Age , count (*) Count_Dist
from 
	Smoker_dis
group by 
	Age
order  by 
	Count_Dist desc

--- Age that have Most Drinker  

With Drinker_Dis as (
Select
	case 
	when age  between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 45 then '36-45'
	when age between 46 and 55 then '46-55'
	when age between 56 and 65 then '56-65'
	else '65'
	end as Age
from 
	Absenteeism_at_work
where
	Social_drinker =1
)

Select 
	Age , count (age) Drinker_dis
from 
	Drinker_Dis
group by 
	Age
order by 
	Drinker_dis desc

--- Age that have BMS > 26

With Body_mass_Dist as (
Select
	case 
	when age  between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 45 then '36-45'
	when age between 46 and 55 then '46-55'
	when age between 56 and 65 then '56-65'
	else '65'
	end as Age
from 
	Absenteeism_at_work
where
	Body_mass_index>26
)

Select 
	Age , count (age) Body_mass_Count
from 
	Body_mass_Dist
group by 
	Age
order by 
	Body_mass_Count desc


--- Age that have most absens
 -- Absens_dist 
WITH Absens_dist AS (
    SELECT
        CASE 
            WHEN age BETWEEN 18 AND 25 THEN '18-25'
            WHEN age BETWEEN 26 AND 35 THEN '26-35'
            WHEN age BETWEEN 36 AND 45 THEN '36-45'
            WHEN age BETWEEN 46 AND 55 THEN '46-55'
            WHEN age BETWEEN 56 AND 65 THEN '56-65'
            ELSE '65+' 
        END AS Age,
        r.Reason AS Reason
    FROM 
        Absenteeism_at_work a
    INNER JOIN 
        Reasons r ON a.Reason_for_absence = r.Number
)
SELECT 
    Reason,
    
 [26-35], 
    [36-45], 
    [46-55], 
    [56-65]  
FROM 
    Absens_dist
PIVOT (
    COUNT(Age) FOR Age IN (
         
        [26-35], 
        [36-45], 
        [46-55], 
        [56-65] 
    )
) AS PivotTable
ORDER BY Reason;


--Number_OF_SON_FOR_NON_Smoker and Number_OF_SON_FOR_NON_Smoker
SELECT 
    [1] AS Social_smoker_1,
    [0] AS Social_smoker_0
FROM 
    (
	SELECT 
		Social_smoker, 
		Son 
	FROM 
		Absenteeism_at_work) AS SourceTable
PIVOT (
    SUM(Son) 
	FOR 
	Social_smoker IN ([1], [0])
) AS PivotTable;

select SUM(case 
			when Absenteeism_at_work.Social_smoker =1 then Son
			else 0
			end )as Number_OF_SON_FOR_Smoker
		,SUM(case 
			when Absenteeism_at_work.Social_smoker =0 then Son
			else 0
			end )as Number_OF_SON_FOR_NON_Smoker
from 
	Absenteeism_at_work




--People that not absens
With S
 
--- Season Absens

With Season_Absens as (
 Select
	case	
		when Month_of_absence in (12,1,2
,0) then 'Winter'
		when Month_of_absence in (3,4,5) then 'Spring'
		when Month_of_absence in (6,7,8) then 'Summer'
		when Month_of_absence in (9,10,11) then 'Fall'
		else 'UnKnown' end as Season_names
 from
	Absenteeism_at_work
)
Select 
	Season_names , Count(*)Number_Of_Absens
from	
	Season_Absens
group by
	Season_names
order by 
	Number_Of_Absens desc

-- Weight Category
With BMI as (
Select 
	case 
		when Body_mass_index <18.5 then 'UnderWeight'
		when Body_mass_index between 18.5 and 25  then 'Normal  Weight'
		when Body_mass_index between 25 and 30  then 'OverWeight'
		when Body_mass_index > 30 then 'Obses'
	Else 
		'NotHaveData'
	end as BMI_Category
from	
	Absenteeism_at_work

)
Select
	BMI_Category ,
	Count (*)BMI_Count
from	
	BMI
group by
	BMI_Category
order by BMI_Count

