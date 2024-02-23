

CREATE TABLE "post_tag" (
"id" INTEGER UNIQUE PRIMARY KEY,
"posts_id" INTEGER NOT NULL,
"tags_id" INTEGER NOT NULL
);


CREATE TABLE "posts" (
"id" INTEGER PRIMARY KEY UNIQUE,
"date" INTEGER NOT NULL,
"dateDay" INTEGER NOT NULL,
"dateMonth" INTEGER NOT NULL,
"dateYear" INTEGER NOT NULL,
"filePath" TEXT NOT NULL,
"hash" TEXT NOT NULL,
"isDraft" INTEGER NOT NULL DEFAULT 0,
"isHomepage" INTEGER DEFAULT 0 NOT NULL,
"isPage" INTEGER NOT NULL DEFAULT 0,
"lastUpdated" TEXT NOT NULL,
"markdown" TEXT,
"renderedMarkdown" TEXT,
"section" TEXT NOT NULL,
"slug" TEXT NOT NULL,
"title" TEXT NOT NULL,
"toml" TEXT,
"url" TEXT NOT NULL,
"verified" INTEGER DEFAULT 0 NOT NULL,
"firstParagraph" TEXT,
"firstParagraphStripped" TEXT
);


CREATE TABLE "tags" (
"id" INTEGER PRIMARY KEY UNIQUE,
"name" TEXT NOT NULL UNIQUE
);
