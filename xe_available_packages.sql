SELECT p.*
FROM sys.dm_xe_packages p
WHERE (p.capabilities IS NULL OR p.capabilities <> 1);