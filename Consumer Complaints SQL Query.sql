-- making table with number of complaints in database for each company
-- making the table means I can query this without having to access the entire database again
CREATE OR REPLACE TABLE consumer_complaints_project.all_companies
AS
SELECT company_name, COUNT(*) as complaint_count
FROM cfpb_consumer_complaint_database.complaint_database
GROUP BY company_name;

-- getting all companies sorted by complaint count
SELECT *
FROM consumer_complaints_project.all_companies
ORDER BY complaint_count DESC;

-- EQUIFAX Inc. appears to have the most complaints in the dataset

-- Going to use only Equifax complaints. Making new table to make each query easier
CREATE OR REPLACE TABLE consumer_complaints_project.equifax_complaints
AS
SELECT *
FROM cfpb_consumer_complaint_database.complaint_database
WHERE company_name = 'EQUIFAX, INC.';

-- looking at the values for complaint columns
SELECT DISTINCT issue FROM consumer_complaints_project.equifax_complaints
UNION DISTINCT (SELECT subissue from consumer_complaints_project.equifax_complaints)
UNION DISTINCT (SELECT company_public_response from consumer_complaints_project.equifax_complaints)
UNION DISTINCT (SELECT consumer_consent_provided from consumer_complaints_project.equifax_complaints)
UNION DISTINCT (SELECT submitted_via from consumer_complaints_project.equifax_complaints)
UNION DISTINCT (SELECT company_response_to_consumer from consumer_complaints_project.equifax_complaints)
UNION DISTINCT (SELECT timely_response from consumer_complaints_project.equifax_complaints)
UNION DISTINCT (SELECT consumer_disputed from consumer_complaints_project.equifax_complaints);

-- looking at number of complaints per 'issue'
SELECT issue, COUNT(issue) as count, COUNT(issue) * 100.0 / (SELECT COUNT(issue) FROM consumer_complaints_project.equifax_complaints) AS percent
FROM consumer_complaints_project.equifax_complaints
GROUP BY issue
ORDER BY count DESC;
-- Incorrect report info, and problem with credit investigation appear to be the most common complaints
-- incorrect report info takes up approximately half of all complaints

-- does this vary by product offerd by Equifax?

SELECT product, issue, COUNT(*) as count, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM consumer_complaints_project.equifax_complaints) AS percent
FROM consumer_complaints_project.equifax_complaints
GROUP BY product, issue
ORDER BY count DESC;
-- credit reporting seems to be the most complained about product
-- incorrect report info takes up the most complaints for the 'credit reporting' product

-- what subissues do we see with the 'incorrect report info' complaint?

SELECT issue, subissue, COUNT(subissue) as count,
COUNT(subissue) * 100 / (SELECT COUNT(subissue) FROM consumer_complaints_project.equifax_complaints WHERE issue = 'Incorrect information on your report') AS percent
FROM consumer_complaints_project.equifax_complaints
WHERE issue = 'Incorrect information on your report'
GROUP BY issue, subissue
ORDER BY count DESC;
-- the most common subissue is that the reporting info belongs to someone else
-- perhaps Equifax needs better matching of client info when creating a report

-- this seems like a pretty simple fix
-- are company responses to this issue-subissue typically timely?
SELECT issue, subissue, timely_response, COUNT(timely_response) as count,
  COUNT(timely_response) * 100 / (SELECT COUNT(timely_response) FROM consumer_complaints_project.equifax_complaints WHERE
  issue = 'Incorrect information on your report' AND subissue = 'Information belongs to someone else') AS percent
FROM consumer_complaints_project.equifax_complaints
WHERE issue = 'Incorrect information on your report' AND subissue = 'Information belongs to someone else'
GROUP BY issue, subissue, timely_response
ORDER BY count DESC;
-- Yes, 99.8% of the time, Equifax gives a timely response.
-- This is a good thing.

-- do customers often dispute this complaint?
SELECT issue, subissue, consumer_disputed, COUNT(consumer_disputed) as count
FROM consumer_complaints_project.equifax_complaints
WHERE issue = 'Incorrect information on your report' AND subissue = 'Information belongs to someone else'
GROUP BY issue, subissue, consumer_disputed
ORDER BY count DESC;
-- no dispute data for this

-- how timely is equifax in general when responding to complaints?
SELECT timely_response, COUNT(timely_response) as count, COUNT(timely_response) * 100 / (SELECT COUNT(timely_response) FROM consumer_complaints_project.equifax_complaints) as percent
FROM consumer_complaints_project.equifax_complaints
GROUP BY timely_response
ORDER BY count DESC;
-- they are timely 99.6% of the time

-- when are they least timely? What issues?
SELECT issue, COUNT(issue) as count, COUNT(issue) * 100.0 / (SELECT COUNT(issue) FROM consumer_complaints_project.equifax_complaints WHERE timely_response = false) AS percent
FROM consumer_complaints_project.equifax_complaints
WHERE timely_response = false
GROUP BY issue
ORDER BY count DESC;
-- the distribution of issues looks approximately the same when compared to total complaints for each issue
-- there is no specific issue that is more timely than others

-- which methods of complaint submission are most common?
SELECT submitted_via, COUNT(*) as count, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM consumer_complaints_project.equifax_complaints) AS percent
FROM consumer_complaints_project.equifax_complaints
GROUP BY submitted_via
ORDER BY count DESC;
-- web submission make up 94% of the complaint submissions

-- Creating a view of submission methods
CREATE OR REPLACE VIEW consumer_complaints_project.submission_freq
AS
SELECT submitted_via, COUNT(*) as count, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM consumer_complaints_project.equifax_complaints) AS percent
FROM consumer_complaints_project.equifax_complaints
GROUP BY submitted_via
ORDER BY count DESC;

SELECT * FROM consumer_complaints_project.submission_freq;
