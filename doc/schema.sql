-- SQL dump generated using DBML (dbml.dbdiagram.io)
-- Database: PostgreSQL
-- Generated at: 2025-02-16T07:47:21.861Z

CREATE TABLE "Organization" (
  "id" integer PRIMARY KEY,
  "name" varchar NOT NULL
);

CREATE TABLE "Student" (
  "id" integer PRIMARY KEY,
  "organization_id" integer NOT NULL,
  "name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL
);

CREATE TABLE "Teacher" (
  "id" integer PRIMARY KEY,
  "organization_id" integer NOT NULL,
  "name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL
);

CREATE TABLE "Class" (
  "id" integer PRIMARY KEY,
  "organization_id" integer NOT NULL,
  "name" varchar NOT NULL,
  "status" enum(active,inactive) NOT NULL DEFAULT 'active'
);

CREATE TABLE "ClassTeacherMapping" (
  "id" integer PRIMARY KEY,
  "class_id" integer NOT NULL,
  "teacher_id" integer NOT NULL,
  "is_primary" boolean NOT NULL DEFAULT false
);

CREATE TABLE "Topic" (
  "id" integer PRIMARY KEY,
  "organization_id" integer NOT NULL,
  "name" varchar NOT NULL,
  "description" text,
  "status" enum(active,inactive) NOT NULL DEFAULT 'active'
);

CREATE TABLE "Skill" (
  "id" integer PRIMARY KEY,
  "topic_id" integer NOT NULL,
  "name" varchar NOT NULL,
  "description" text,
  "parent_skill_id" integer
);

CREATE TABLE "MockTest" (
  "id" integer PRIMARY KEY,
  "organization_id" integer NOT NULL,
  "topic_id" integer NOT NULL,
  "name" varchar NOT NULL,
  "description" text,
  "total_duration" integer NOT NULL,
  "status" enum(draft,published,archived) NOT NULL DEFAULT 'draft'
);

CREATE TABLE "MockTestSkill" (
  "id" integer PRIMARY KEY,
  "mock_test_id" integer NOT NULL,
  "skill_id" integer NOT NULL,
  "order_index" integer NOT NULL,
  "duration" integer NOT NULL
);

CREATE TABLE "TestSession" (
  "id" integer PRIMARY KEY,
  "mock_test_id" integer NOT NULL,
  "student_id" integer NOT NULL,
  "class_id" integer,
  "status" enum(pending,in_progress,completed) NOT NULL DEFAULT 'pending',
  "started_at" timestamp,
  "completed_at" timestamp
);

CREATE TABLE "TestSubmission" (
  "id" integer PRIMARY KEY,
  "test_session_id" integer NOT NULL,
  "mock_test_skill_id" integer NOT NULL,
  "submission_type" enum(audio,video,text) NOT NULL,
  "submission_url" text NOT NULL,
  "transcript" text,
  "auto_graded_score" float
);

CREATE TABLE "TestResult" (
  "id" integer PRIMARY KEY,
  "test_submission_id" integer NOT NULL,
  "score" float NOT NULL,
  "feedback" text
);

CREATE INDEX ON "Organization" ("name");

CREATE INDEX ON "Student" ("organization_id");

CREATE INDEX ON "Student" ("email");

CREATE INDEX ON "Student" ("organization_id", "email");

CREATE INDEX ON "Teacher" ("organization_id");

CREATE INDEX ON "Teacher" ("email");

CREATE INDEX ON "Teacher" ("organization_id", "email");

CREATE INDEX ON "Class" ("organization_id");

CREATE INDEX ON "Class" ("organization_id", "name");

CREATE INDEX ON "ClassTeacherMapping" ("class_id", "teacher_id");

CREATE INDEX ON "Topic" ("organization_id");

CREATE INDEX ON "Topic" ("organization_id", "name");

CREATE INDEX ON "Skill" ("topic_id");

CREATE INDEX ON "Skill" ("parent_skill_id");

CREATE INDEX ON "MockTest" ("organization_id");

CREATE INDEX ON "MockTest" ("topic_id");

CREATE INDEX ON "MockTest" ("organization_id", "topic_id");

CREATE INDEX ON "MockTestSkill" ("mock_test_id", "skill_id");

CREATE INDEX ON "MockTestSkill" ("mock_test_id", "order_index");

CREATE INDEX ON "TestSession" ("mock_test_id");

CREATE INDEX ON "TestSession" ("student_id");

CREATE INDEX ON "TestSession" ("class_id");

CREATE INDEX ON "TestSession" ("mock_test_id", "student_id");

CREATE INDEX ON "TestSubmission" ("test_session_id");

CREATE INDEX ON "TestSubmission" ("mock_test_skill_id");

CREATE INDEX ON "TestSubmission" ("test_session_id", "mock_test_skill_id");

CREATE INDEX ON "TestResult" ("test_submission_id");

ALTER TABLE "Student" ADD FOREIGN KEY ("organization_id") REFERENCES "Organization" ("id");

ALTER TABLE "Teacher" ADD FOREIGN KEY ("organization_id") REFERENCES "Organization" ("id");

ALTER TABLE "Class" ADD FOREIGN KEY ("organization_id") REFERENCES "Organization" ("id");

ALTER TABLE "ClassTeacherMapping" ADD FOREIGN KEY ("class_id") REFERENCES "Class" ("id");

ALTER TABLE "ClassTeacherMapping" ADD FOREIGN KEY ("teacher_id") REFERENCES "Teacher" ("id");

ALTER TABLE "Topic" ADD FOREIGN KEY ("organization_id") REFERENCES "Organization" ("id");

ALTER TABLE "Skill" ADD FOREIGN KEY ("topic_id") REFERENCES "Topic" ("id");

ALTER TABLE "Skill" ADD FOREIGN KEY ("parent_skill_id") REFERENCES "Skill" ("id");

ALTER TABLE "MockTest" ADD FOREIGN KEY ("organization_id") REFERENCES "Organization" ("id");

ALTER TABLE "MockTest" ADD FOREIGN KEY ("topic_id") REFERENCES "Topic" ("id");

ALTER TABLE "MockTestSkill" ADD FOREIGN KEY ("mock_test_id") REFERENCES "MockTest" ("id");

ALTER TABLE "MockTestSkill" ADD FOREIGN KEY ("skill_id") REFERENCES "Skill" ("id");

ALTER TABLE "TestSession" ADD FOREIGN KEY ("mock_test_id") REFERENCES "MockTest" ("id");

ALTER TABLE "TestSession" ADD FOREIGN KEY ("student_id") REFERENCES "Student" ("id");

ALTER TABLE "TestSession" ADD FOREIGN KEY ("class_id") REFERENCES "Class" ("id");

ALTER TABLE "TestSubmission" ADD FOREIGN KEY ("test_session_id") REFERENCES "TestSession" ("id");

ALTER TABLE "TestSubmission" ADD FOREIGN KEY ("mock_test_skill_id") REFERENCES "MockTestSkill" ("id");

ALTER TABLE "TestResult" ADD FOREIGN KEY ("test_submission_id") REFERENCES "TestSubmission" ("id");

ALTER TABLE "MockTest" ADD FOREIGN KEY ("description") REFERENCES "MockTest" ("name");
