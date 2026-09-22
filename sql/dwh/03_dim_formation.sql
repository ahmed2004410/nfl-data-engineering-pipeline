Drop table if exists dwh.dim_formation ;
Create table dwh.dim_formation (
    formation_key INTEGER generated always as identity primary key,
    offense_formation VARCHAR(100) NOT NULL,
    rb_count INTEGER NOT NULL,
    te_count INTEGER NOT NULL,
    wr_count INTEGER NOT NULL,
    dl_count INTEGER NOT NULL,
    lb_count INTEGER NOT NULL,
    db_count INTEGER NOT NULL
);


INSERT INTO dwh.dim_formation (offense_formation, rb_count, te_count, wr_count, dl_count, lb_count, db_count)
SELECT DISTINCT 
offense_formation,
COALESCE(substring(personnel_o from '(\d+)\s*RB')::INTEGER, 0) AS rb_count,
COALESCE(substring(personnel_o from '(\d+)\s*TE')::INTEGER, 0) AS te_count,
COALESCE(substring(personnel_o from '(\d+)\s*WR')::INTEGER, 0) AS wr_count,
COALESCE(substring(personnel_d from '(\d+)\s*DL')::INTEGER, 0) AS dl_count,
COALESCE(substring(personnel_d from '(\d+)\s*LB')::INTEGER, 0) AS lb_count,
COALESCE(substring(personnel_d from '(\d+)\s*DB')::INTEGER, 0) AS db_count
FROM staging.plays
WHERE offense_formation IS NOT NULL
ORDER BY offense_formation;

-- صف الـ UNKNOWN: بيمثل أي play مالوش offense_formation
-- أو combination من personnel_o/personnel_d مش موجودة أصلاً
INSERT INTO dwh.dim_formation (offense_formation, rb_count, te_count, wr_count, dl_count, lb_count, db_count)
VALUES ('UNKNOWN', -1, -1, -1, -1, -1, -1);