package batch;//package batch;

/*------------------------------------------------------------------------------
 * Name : E16HealthSendMailBatch
 * DESC :  EMS
 * VER  : 1.0
 * PROJ : LG
 * Copyright 2010 LG   All rights reserved
 *------------------------------------------------------------------------------
 *
 *------------------------------------------------------------------------------
 *     DATE        AUTHOR                       DESCRIPTION
 *-------------  ----------  ---------------------------------------------------
 * 2010. 06. 23          LSA                     ver1.0
 * 2017. 05. 25          eunha                  [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치
 * 														 493line 상단과 하단에 주석으로 처리된 부분에 connection 정보 노출. 해당 주석부분 삭제
 *----------------------------------------------------------------------------*/

//package batch;

import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Client;
import com.sap.mw.jco.JCO.Repository;
import com.sap.mw.jco.JCO.Pool;
import com.sap.mw.jco.IRepository;
import com.sap.mw.jco.IFunctionTemplate;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.Logger;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class E16HealthSendMailBatch {

    Client JCOClient = null;
    String poolName = "";
    static String strLOG_FILE_EXT = "log";
    static String strREAL_LOG_NAME = "";
    static String strLOG_FILE_NAME = "";
    //String strSaveDirectory = "/usr/Application/ehr/ehr.ear/ehrWeb.war/log/"; // DEV , PROD
    String strSaveDirectory = "/sorc001/gehr/gehr.ear/gehrWeb.war/log/"; // DEV , PROD

    JCO.Table IT_MAIL = null;
    JCO.Table IT_PERNR = null;
    JCO.Table IT_MAIL2 = null;
    JCO.Table IT_PERNR2 = null;

    public static void main(String[] arg){

        Logger.debug( " E16HealthSendMailBatch main Start... " );
        new E16HealthSendMailBatch().work();
        Logger.debug( " E16HealthSendMailBatch main End... " );

     } // end run

    public void work() {

        int iResult = 0;
        try {
            Logger.debug( " work Start... " );

            strREAL_LOG_NAME = "E16HealthSendMailBatch" + getPlainDate("yyyyMMddHHmmss") + "." + strLOG_FILE_EXT;
            strLOG_FILE_NAME = strSaveDirectory + strREAL_LOG_NAME;
            // RFC Mail Data
            getRfcMailData();

            if(IT_MAIL.getNumRows() > 0){
                // EMS DB INSERT
                iResult = insertEmsMailData(IT_MAIL, IT_PERNR);
            }
            if(IT_MAIL2.getNumRows() > 0){
                // EMS DB INSERT
                iResult = insertEmsMailData(IT_MAIL2, IT_PERNR2);
            }

        } catch(Exception e){
            Logger.debug("Exception occured :");
            Logger.error(e);
        }finally
        {
            try{
            }catch(Exception e){}
        }
    } // end work

    public void getRfcMailData() throws Exception {

            String functionName = "ZHRW_RFC_INTRST_BATCH_MAIL_HC";
            LogMaker aLogMaker = new LogMaker();
        try {
            Logger.debug( " getRfcMailData Start... " );

            initJCOClient();
            IRepository repository = getRepository();
            IFunctionTemplate ftemplate = repository.getFunctionTemplate( functionName );

            JCO.Function function = new JCO.Function( ftemplate );

            JCO.ParameterList importParameter = function.getImportParameterList();
            //importParameter.setValue(strIM_GUBUN, "IM_GUBUN" );
            //
            //if( strIM_GUBUN.equals("U") ) {
            //    importParameter.setValue( "Y", "IM_MAILYN" );
            //}
            JCO.ParameterList tableParameter = function.getTableParameterList();

            JCOClient.execute( function );

            IT_MAIL = tableParameter.getTable( "IT_MAIL1" );

            IT_PERNR =  tableParameter.getTable("IT_PERNR1" );
            IT_MAIL2 = tableParameter.getTable( "IT_MAIL2" );

            IT_PERNR2 =  tableParameter.getTable("IT_PERNR2" );

        } catch ( JCO.Exception jcoex ) {
            aLogMaker.writeLog(  strLOG_FILE_NAME, "getRfcMailData : jcoex : " + jcoex.toString());
            throw new Exception( jcoex.getMessage(), jcoex );
        } catch ( Exception ex ) {
            aLogMaker.writeLog(  strLOG_FILE_NAME, "getRfcMailData : jcoex : " + ex.toString());
            throw new Exception( ex.getMessage(), ex );
        } finally {
            try {
                JCO.releaseClient( JCOClient );
            } catch ( JCO.Exception jcoex ) {
                throw new Exception( jcoex.getMessage(), jcoex );
            } catch ( Exception ex ) {
                throw new Exception( ex.getMessage(), ex );
            }
            Logger.debug( "JCO Client Released. poolName : [" + poolName + "]" );
        }

    } // end getRfcMailData
    public int insertEmsMailData(JCO.Table IT_MAIL,JCO.Table IT_PERNR) throws Exception {

         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs  = null;

        String strMaxSeqSql = "";
        String strMaxSeq = "";
        String strFormSql = "";
        String strListSql = "";
        String strUpdFormSql = "";


        int iResult = 0;
        int rowNum = 0;

        int subCnt = 0;

        LogMaker aLogMaker = new LogMaker();

        try {

            Logger.debug( " insertEmsMailData Start... " );

            int rowNumber = IT_MAIL.getNumRows();

            if(rowNumber > 0){
                String[] SEQ                  = new String[rowNumber];
                String[] MAIL_KIND        = new String[rowNumber];
                String[] REGDATE          = new String[rowNumber];
                String[] CONTENT          = new String[rowNumber];
                String[] SUBJECT          = new String[rowNumber];
                String[] SEND_EMAIL       = new String[rowNumber];
                String[] SEND_NAME        = new String[rowNumber];
                String[] RETURN_EMAIL     = new String[rowNumber];
                String[] SEND_FLAG        = new String[rowNumber];
                String[] LIST_ENDFLAG     = new String[rowNumber];
                String[] ATTACH_FILE1     = new String[rowNumber];
                String[] ATTACH_FILENM1   = new String[rowNumber];
                String[] ATTACH_FILE2     = new String[rowNumber];
                String[] ATTACH_FILENM2   = new String[rowNumber];
                String[] ATTACH_FILE3     = new String[rowNumber];
                String[] ATTACH_FILENM3   = new String[rowNumber];
                String[] ATTACH_FILE4     = new String[rowNumber];
                String[] ATTACH_FILENM4   = new String[rowNumber];
                String[] ATTACH_FILE5     = new String[rowNumber];
                String[] ATTACH_FILENM5   = new String[rowNumber];
                String[] ZOBJID           = new String[rowNumber];

                int n = 0;

                do{
                    SEQ[n]            = getNullTrans(IT_MAIL.getString("SEQ"));
                    MAIL_KIND[n]      = getNullTrans(IT_MAIL.getString("MAIL_KIND"));
                    REGDATE[n]        = getNullTrans(IT_MAIL.getString("REGDATE"));
                    CONTENT[n]        = getNullTrans(IT_MAIL.getString("CONTENT"));
                    SUBJECT[n]        = getNullTrans(IT_MAIL.getString("SUBJECT"));
                    SEND_EMAIL[n]     = getNullTrans(IT_MAIL.getString("SEND_EMAIL"));
                    SEND_NAME[n]      = getNullTrans(IT_MAIL.getString("SEND_NAME"));
                    RETURN_EMAIL[n]   = getNullTrans(IT_MAIL.getString("RETURN_EMAIL"));
                    SEND_FLAG[n]      = getNullTrans(IT_MAIL.getString("SEND_FLAG"));
                    LIST_ENDFLAG[n]   = getNullTrans(IT_MAIL.getString("LIST_ENDFLAG"));
                    ATTACH_FILE1[n]   = getNullTrans(IT_MAIL.getString("ATTACH_FILE1"));
                    ATTACH_FILENM1[n] = getNullTrans(IT_MAIL.getString("ATTACH_FILENM1"));
                    ATTACH_FILE2[n]   = getNullTrans(IT_MAIL.getString("ATTACH_FILE2"));
                    ATTACH_FILENM2[n] = getNullTrans(IT_MAIL.getString("ATTACH_FILENM2"));
                    ATTACH_FILE3[n]   = getNullTrans(IT_MAIL.getString("ATTACH_FILE3"));
                    ATTACH_FILENM3[n] = getNullTrans(IT_MAIL.getString("ATTACH_FILENM3"));
                    ATTACH_FILE4[n]   = getNullTrans(IT_MAIL.getString("ATTACH_FILE4"));
                    ATTACH_FILENM4[n] = getNullTrans(IT_MAIL.getString("ATTACH_FILENM4"));
                    ATTACH_FILE5[n]   = getNullTrans(IT_MAIL.getString("ATTACH_FILE5"));
                    ATTACH_FILENM5[n] = getNullTrans(IT_MAIL.getString("ATTACH_FILENM5"));
                    ZOBJID[n]         = getNullTrans(IT_MAIL.getString("ZOBJID"));

                    n++ ;
                } while (IT_MAIL.nextRow()); // end do-while



                rowNum = IT_PERNR.getNumRows();

                if(rowNum > 0){
                    String[] EMAIL     =   new String[rowNum];
                    String[] NAME      =   new String[rowNum];
                    String[] MAPPING1  =   new String[rowNum];
                    String[] MAPPING2  =   new String[rowNum];
                    String[] MAPPING3  =   new String[rowNum];
                    String[] MAPPING4  =   new String[rowNum];
                    String[] MAPPING5  =   new String[rowNum];
                    String[] MAPPING6  =   new String[rowNum];
                    String[] MAPPING7  =   new String[rowNum];
                    String[] MAPPING8  =   new String[rowNum];
                    String[] MAPPING9  =   new String[rowNum];
                    String[] MAPPING10 =   new String[rowNum];
                    String[] OBJID =  new String[rowNum];

                    int k = 0;

                    do{
                            EMAIL[k]     =   getNullTrans(IT_PERNR.getString("EMAIL"));
                            NAME[k]      =   getNullTrans(IT_PERNR.getString("NAME"));
                            MAPPING1[k]  =   getNullTrans(IT_PERNR.getString("MAPPING1"));
                            MAPPING2[k]  =   getNullTrans(IT_PERNR.getString("MAPPING2"));
                            MAPPING3[k]  =   getNullTrans(IT_PERNR.getString("MAPPING3"));
                            MAPPING4[k]  =   getNullTrans(IT_PERNR.getString("MAPPING4"));
                            MAPPING5[k]  =   getNullTrans(IT_PERNR.getString("MAPPING5"));
                            MAPPING6[k]  =   getNullTrans(IT_PERNR.getString("MAPPING6"));
                            MAPPING7[k]  =   getNullTrans(IT_PERNR.getString("MAPPING7"));
                            MAPPING8[k]  =   getNullTrans(IT_PERNR.getString("MAPPING8"));
                            MAPPING9[k]  =   getNullTrans(IT_PERNR.getString("MAPPING9"));
                            MAPPING10[k] =   getNullTrans(IT_PERNR.getString("MAPPING10"));
                            OBJID[k] =  getNullTrans(IT_PERNR.getString("ZOBJID"));
                        k++ ;
                    } while (IT_PERNR.nextRow()); // end do-while

                    for(int i = 0; i < rowNumber; i++){

                        conn = getConnection();

                        conn.setAutoCommit(false);

                        strMaxSeqSql = " SELECT NVL(MAX(SEQ),'0') + 1 AS seq ";
                        strMaxSeqSql = strMaxSeqSql + " FROM   EV_SEND_FORM ";

                        pstmt = conn.prepareStatement(strMaxSeqSql);
                        rs = pstmt.executeQuery();

//                        Logger.debug( " insertEmsMailData strMaxSeqSql :  "  + strMaxSeqSql );

                        if( rs.next() ) {

                            strMaxSeq = rs.getString( "seq" );
                            Logger.debug(" insertEmsMailData strMaxSeq : " + strMaxSeq);

                            rs.close();
                            pstmt.close();

                            // Form

                            //String Subject = "[" + SUBJECT[i] +"] " + MAPPING2[subCnt] + " ()   ";
                            //Logger.debug("Subject +++++>>>>>>>" + Subject);

                            strFormSql = " INSERT INTO EV_SEND_FORM ( ";
                            strFormSql = strFormSql + "   SEQ ";
                            strFormSql = strFormSql + " , MAIL_KIND ";
                            strFormSql = strFormSql + " , REGDATE ";
                            strFormSql = strFormSql + " , CONTENT ";
                            strFormSql = strFormSql + " , SUBJECT ";
                            strFormSql = strFormSql + " , SEND_EMAIL ";
                            strFormSql = strFormSql + " , SEND_NAME ";
                            strFormSql = strFormSql + " , RETURN_EMAIL ";
                            strFormSql = strFormSql + " , SEND_FLAG ";
                            strFormSql = strFormSql + " , LIST_ENDFLAG ";
                            strFormSql = strFormSql + " , ATTACH_FILE1 ";
                            strFormSql = strFormSql + " , ATTACH_FILENM1 ";
                            strFormSql = strFormSql + " , ATTACH_FILE2 ";
                            strFormSql = strFormSql + " , ATTACH_FILENM2 ";
                            strFormSql = strFormSql + " , ATTACH_FILE3 ";
                            strFormSql = strFormSql + " , ATTACH_FILENM3 ";
                            strFormSql = strFormSql + " , ATTACH_FILE4 ";
                            strFormSql = strFormSql + " , ATTACH_FILENM4 ";
                            strFormSql = strFormSql + " , ATTACH_FILE5 ";
                            strFormSql = strFormSql + " , ATTACH_FILENM5 ";
                            strFormSql = strFormSql + " ) VALUES ( ";
                            strFormSql = strFormSql + "  ?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,sysdate + ( 3 / (24*60))  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ,?  ";
                            strFormSql = strFormSql + " ) ";

             Logger.debug("strFormSql +++++>>>>>>>" + strFormSql);
                            pstmt = conn.prepareStatement(strFormSql);

                            pstmt.setString(1,strMaxSeq);
                            pstmt.setString(2,MAIL_KIND[i]);
                            pstmt.setString(3,CONTENT[i]);
                            pstmt.setString(4,SUBJECT[i]);
                            pstmt.setString(5,SEND_EMAIL[i]);
                            pstmt.setString(6,SEND_NAME[i]);
                            pstmt.setString(7,RETURN_EMAIL[i]);
                            pstmt.setString(8,SEND_FLAG[i]);
                            pstmt.setString(9,LIST_ENDFLAG[i]);
                            pstmt.setString(10,ATTACH_FILE1[i]);
                            pstmt.setString(11,ATTACH_FILENM1[i]);
                            pstmt.setString(12,ATTACH_FILE2[i]);
                            pstmt.setString(13,ATTACH_FILENM2[i]);
                            pstmt.setString(14,ATTACH_FILE3[i]);
                            pstmt.setString(15,ATTACH_FILENM3[i]);
                            pstmt.setString(16,ATTACH_FILE4[i]);
                            pstmt.setString(17,ATTACH_FILENM4[i]);
                            pstmt.setString(18,ATTACH_FILE5[i]);
                            pstmt.setString(19,ATTACH_FILENM5[i]);
                            iResult = pstmt.executeUpdate();

                            Logger.debug(" Form iResult : " + iResult);


                            if( iResult > 0 ) {
                                pstmt.close();

                                strListSql = " INSERT INTO EV_SEND_LIST ( ";
                                strListSql = strListSql + "   SEQ ";
                                strListSql = strListSql + " , LIST_SEQ ";
                                strListSql = strListSql + " , EMAIL ";
                                strListSql = strListSql + " , NAME ";
                                strListSql = strListSql + " , MAPPING1 ";
                                strListSql = strListSql + " , MAPPING2 ";
                                strListSql = strListSql + " , MAPPING3 ";
                                strListSql = strListSql + " , MAPPING4 ";
                                strListSql = strListSql + " , MAPPING5 ";
                                strListSql = strListSql + " , MAPPING6 ";
                                strListSql = strListSql + " , MAPPING7 ";
                                strListSql = strListSql + " , MAPPING8 ";
                                strListSql = strListSql + " , MAPPING9 ";
                                strListSql = strListSql + " , MAPPING10 ";
                                strListSql = strListSql + " ) VALUES ( ";
                                strListSql = strListSql + "   ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + " , ? ";
                                strListSql = strListSql + "  )   ";

                                pstmt = conn.prepareStatement(strListSql);

                                rowNum = IT_PERNR.getNumRows();

                                Logger.debug(" insertEmsMailData rowNum : " + rowNum);


                                if(rowNum > 0){
                                    int z = 0;
                                    for( int j=0 ; j < rowNum ; j++) {
                                        pstmt.setString(1,strMaxSeq);
                                        if(ZOBJID[i].equals( OBJID[j])){
                                            pstmt.setInt(2,(z+1));
                                            pstmt.setString(3,EMAIL[j]);
                                            pstmt.setString(4,NAME[j]);
                                            pstmt.setString(5,MAPPING1[j]);
                                            pstmt.setString(6,MAPPING2[j]);
                                            pstmt.setString(7,MAPPING3[j]);
                                            pstmt.setString(8,MAPPING4[j]);
                                            pstmt.setString(9,MAPPING5[j]);
                                            pstmt.setString(10,MAPPING6[j]);
                                            pstmt.setString(11,MAPPING7[j]);
                                            pstmt.setString(12,MAPPING8[j]);
                                            pstmt.setString(13,MAPPING9[j]);
                                            pstmt.setString(14,MAPPING10[j]);
                                            iResult = pstmt.executeUpdate();

                                            Logger.debug(" List["+j+"] iResult : " + iResult);
                                            z++;
                                            subCnt++;
                                        }

                                    } // end for

                                } // end if


                                if( iResult > 0 ) {
                                    pstmt.close();

                                    strUpdFormSql = " UPDATE EV_SEND_FORM SET ";
                                    strUpdFormSql = strUpdFormSql + " LIST_ENDFLAG = 'Y' ";
                                    strUpdFormSql = strUpdFormSql + " WHERE SEQ = ?  ";

                                    pstmt = conn.prepareStatement(strUpdFormSql);
                                    pstmt.setString(1,strMaxSeq);
                                    iResult = pstmt.executeUpdate();
    //                                iResult = 1;
                                    Logger.debug(" Update iResult : " + iResult);


                                    if( iResult > 0 ) {
                                        conn.commit();
                                        aLogMaker.writeLog(  strLOG_FILE_NAME, "insertEmsMailData : conn.commit() : ");

                                    } else {
                                        conn.rollback();
                                    }
                                } else {
                                    conn.rollback();
                                }
                            } else {
                                conn.rollback();
                            }
                        }else {
                            conn.rollback();
                        }
                    } //end for.
                }
            }// end if.

        } catch (SQLException ee) {
            conn.rollback();
            Logger.error(ee);
//            Logger.debug(  this.getClass().getName() + ".insertEmsMailData()" + "=>" + ee.getMessage());
            aLogMaker.writeLog(  strLOG_FILE_NAME, "insertEmsMailData :ee : " + ee.toString() );
            throw new Exception( ee.getMessage(), ee);
        } catch (Exception e) {
            Logger.error(e);
//            Logger.debug(  this.getClass().getName() + ".insertEmsMailData()" + "=>" + e.getMessage());
            aLogMaker.writeLog(  strLOG_FILE_NAME, "insertEmsMailData :ee : " + e.toString() );
            throw new Exception( e.getMessage(), e);
        } finally {
            rs.close();
            pstmt.close();
            conn.close();
        }

        return iResult;

    } // end insertEmsMailData

    public static Connection getConnection() {
        Connection conn = null;
        LogMaker aLogMaker = new LogMaker();
        try {
            Config conf = new Configuration();

            String webuser = conf.getString("com.sns.jdf.emsDB.webuser");
            String passwd = conf.getString("com.sns.jdf.emsDB.passwd");

            String url = conf.getString("com.sns.jdf.emsDB.url");



            //Load the Oracle JDBC driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(url, webuser, passwd);

        } catch (ClassNotFoundException nf) {
            aLogMaker.writeLog(strLOG_FILE_NAME, "Connection Error : ClassNotFoundException");
        } catch (SQLException e) {
            aLogMaker.writeLog(strLOG_FILE_NAME, "Connection Error : SQLException");
            Logger.error(e);
        } catch (Exception e1) {
            Logger.error(e1);
        }

         return conn;
      } // end getConnection


    protected void initJCOClient() {
        LogMaker aLogMaker = new LogMaker();
        try {
            //DEV
           // int maxConnection = 10 ;
           // String sapClient = "310";
           // String sapUser = "sapess";
           // String sapPass = "HRESS01";
           // String language = "KO";
           // String sapHost = "165.244.235.81";
           // String sapSysnr = "01";
           // this.poolName = "DEV" ;

           // // PRD
                int maxConnection = 100 ;
                String sapClient = "100";
                String sapUser = "sapess";
                String sapPass = "HRESS01";
                String language = "KO";
                String sapHost = "165.244.235.102";

                String sapSysnr = "00";
                this.poolName = "PRD" ;

            Pool pool = JCO.getClientPoolManager().getPool( poolName );

            if ( pool == null ) {
                JCO.addClientPool( poolName, maxConnection, sapClient, sapUser, sapPass, language,
                        sapHost, sapSysnr );
                Logger.debug( "JCO Client Pool Added. poolName : [" + poolName + "]" );
            }

            aLogMaker.writeLog(  strLOG_FILE_NAME, "initJCOClient sapUser : sapUser:" +sapUser);
            aLogMaker.writeLog(  strLOG_FILE_NAME, "initJCOClient Error :sapPass :"+sapPass );
            aLogMaker.writeLog(  strLOG_FILE_NAME, "initJCOClient Error sapHost: "+sapHost );
            aLogMaker.writeLog(  strLOG_FILE_NAME, "initJCOClient Error poolName: "+poolName );
            JCOClient = JCO.getClient( poolName );
            Logger.debug( "JCO Client Get. poolName : [" + poolName + "]" );
        } catch ( JCO.Exception jcoex ) {
            aLogMaker.writeLog(  strLOG_FILE_NAME, "initJCOClient Error : JCO.Exception" );
            Logger.debug( "JCO Exception occurred - " + jcoex.toString() );
        } catch ( Exception ex ) {
            Logger.debug( "Unexpected Exception occurred - " + ex.toString() );
            aLogMaker.writeLog(  strLOG_FILE_NAME, "initJCOClient Error : Exception" );
        }
    } // end initJCOClient

    private IRepository getRepository() throws Exception {

        Repository mRepository = null;

        try {
            mRepository = new JCO.Repository( "MYRepository", this.poolName );
            Logger.debug("getRepository()    mRepository:::::" + mRepository);
        } catch ( JCO.Exception jcoex ) {
            throw new Exception( jcoex.getMessage(), jcoex );
        } catch ( Exception ex ) {
            throw new Exception( ex.getMessage(), ex );
        }

        return mRepository;
    } // end getRepository

    public static String getNullTrans( String sData, String sTrans ) {

        if ( sTrans == null )
            sTrans = "";
        if ( sData == null || "".equals( sData ) || "null".equals( sData ) )
            sData = sTrans;
        return sData;
    }

    public static String getNullTrans( String sData ) {
        String    sTrans = "";
        if ( sData == null || "".equals( sData ) || "null".equals( sData ) )
            sData = sTrans;
        return sData;
    } // end getNullTrans

    /**
     * sap
     *
     * @param in
     * @return
     */
    public static String convertInitialize( String in ) {

        String out = "";

        in = getNullTrans( in );
        if ( in != "" ) {
            if ( in.equals( "0" ) ) {
                out = "";
            } else if ( in.equals( "00000000" ) ) {
                out = "";
            } else if ( in.equals( "0000-00-00" ) ) {
                out = "";
            } else {
                out = in;
            }
        }

        return out;

    } // end convertInitialize

    /**
     * <pre System date YYYYMMDD  </pre>
     *
     * @param
     * @return      String
     */
    public static String getPlainDate(String sFormat) {
        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(sFormat);
        java.util.Date currentDate_1 = new java.util.Date();
        String date = formatter.format(currentDate_1);
        return date;
    }
}
