-- 新浪微博数据库
CREATE TABLE IF NOT EXISTS "T_Status" (
"statusId" INTEGER NOT NULL,
"status" TEXT,
"userId" INTEGER,
"creatTime" TEXT DEFAULT (datetime('now', 'localtime')),
PRIMARY KEY("statusId")
);