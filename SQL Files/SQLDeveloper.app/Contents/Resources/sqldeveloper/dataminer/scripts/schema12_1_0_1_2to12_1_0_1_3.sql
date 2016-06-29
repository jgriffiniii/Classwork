-- schema12_1_0_1_2to12_1_0_1_3.sql is used by the migration process to migrate the XML Schema from 12_1_0_1_2 to 12.1.0.1.3
-- Usage @schema12_1_0_1_2to12_1_0_1_3.sql

WHENEVER SQLERROR EXIT SQL.SQLCODE;

ALTER session set current_schema = "SYS";
/

EXECUTE dbms_output.put_line('Start Data Miner XML Schema migration from 12_1_0_1_2 to 12.1.0.1.3 ' || systimestamp);

DECLARE
  ver_num         VARCHAR2(30);
  v_storage       VARCHAR2(30);
BEGIN
  SELECT STORAGE_TYPE INTO v_storage FROM ALL_XML_TAB_COLS WHERE OWNER='ODMRSYS' AND TABLE_NAME='ODMR$WORKFLOWS' AND COLUMN_NAME='WORKFLOW_DATA';
  SELECT PROPERTY_STR_VALUE INTO ver_num FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'WF_VERSION';
  dbms_output.put_line('Current xml schema version in database: ' || to_char(ver_num));
  IF (ver_num = '12.1.0.1.2') THEN
--    Add OR and BINARY migration specific script by uncommenting out the if else below. There may not be any migration script required.
--    IF (v_storage != 'BINARY') THEN
--    ELSE
--    END IF;
    dbms_output.put_line('Workflow schema migration from version 12_1_0_1_2 to 12.1.0.1.3 succeeded.');
    -- uptick the WF_VERSION
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = '12.1.0.1.3' WHERE PROPERTY_NAME = 'WF_VERSION';
    COMMIT;
  END IF;  
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.put_line('Workflow schema migration from version 12_1_0_1_2 to 12.1.0.1.3 failed: '||DBMS_UTILITY.FORMAT_ERROR_STACK());
  RAISE;
END;
/

ALTER session set current_schema = "ODMRSYS";

DECLARE
  ver_num   VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO ver_num FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'WF_VERSION';
  IF (ver_num = '12.1.0.1.3') THEN
    UPDATE ODMRSYS.ODMR$WORKFLOWS x
      SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA, '/WorkflowProcess/@Version', ver_num, 'xmlns="http://xmlns.oracle.com/odmr11"')
    WHERE XMLExists('declare default element namespace "http://xmlns.oracle.com/odmr11";
      $p/WorkflowProcess' PASSING x.WORKFLOW_DATA AS "p");
    COMMIT;
    dbms_output.put_line('Migrated workflows version have been updated to version 12.1.0.1.3');
  END IF;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.put_line('Migrated workflows version update failed: '||DBMS_UTILITY.FORMAT_ERROR_STACK());
  RAISE;
END;
/

EXECUTE dbms_output.put_line('End Data Miner XML Schema migration from 12_1_0_1_2 to 12.1.0.1.3 ' || systimestamp);
