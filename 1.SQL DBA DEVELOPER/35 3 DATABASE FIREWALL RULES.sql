-- YOU NEED TO CONNECT TO THE REQUIRED DATABASE. 

-- QUERY 1: HOW TO FIND THE LIST OF ALL FIREWALLS IN AZURE SQL DATABASE
SELECT * FROM sys.database_firewall_rules;


-- QUERY 2: HOW TO SET A NEW FIREWALL RULE?
EXECUTE sp_set_database_firewall_rule @name = N'SQLSchoolFirewallRule',
@start_ip_address = '192.168.1.1', @end_ip_address = '192.168.1.10'


-- QUERY 3: TO VERIFY ABOVE NEW FIREWALL ENTRY?
SELECT * FROM sys.database_firewall_rules ORDER BY name;


-- QUERY 4: HOW TO DELETE OR REMOVE AN EXISTING FIREWALL RULE?
EXECUTE sp_delete_database_firewall_rule @name = N'SQLSchoolFirewallRule'