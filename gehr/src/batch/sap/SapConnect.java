package batch.sap;

/******************************************************************************
 *
 *    Program iD   : SapConnect
 *
 *    Description  : SAP connect
 *
 *    Class        : SapConnect
 *
 *******************************************************************************
 *                                MODiFiCATiON LOG
 *
 *       DATE        AUTHORS                      DESCRiPTiON
 *    ----------    ---------    -----------------------------------------------
 *    2001/12/05     유광섭       initial Release
 *
 ********************************************************************************/

import com.sap.mw.jco.IRepository;
import com.sap.mw.jco.JCO;

import java.io.FileOutputStream;
import java.io.IOException;

public class SapConnect {

    public static String PoolName = "sappool_oem";

    public static JCO.Repository mRepository;

    private JCO.Client JCOClient = null;

    /**
     * DEFAULT생성자
     */
    public SapConnect() {}

    /** sap connect method **/

    String LOG_FILE = "/home/qasadm/oem/sub_pgm/log/week_sap.log";

    public void writeToFile(String str){
        try {
            FileOutputStream fw = new FileOutputStream(LOG_FILE, true);

            byte[] c = new byte[200];
            c = str.getBytes();

            fw.write(c);
            fw.write("\n".getBytes());
            fw.flush();
            fw.close();

        } catch (IOException e) {
        }
    }

    public IRepository zconnect(){
        try {
            JCO.Pool pool = JCO.getClientPoolManager().getPool(PoolName);
            if (pool == null) {
                /*                
                 JCO.addClientPool(PoolName, 		    // Alias for this pool
                 300, 		            // Max. number of connections
                 "310",		            // SAP client 
                 "oemrfc",              // userid  rfcorder oemrfc
                 "basis",	            // password  init  basis
                 "KO",   	            // language
                 "165.244.235.81",      // host name (Ip Address) 165.244.235.84
                 "01");                 // system no.10

                 Logger.debug("zconnect = 310 165.244.235.81 01" );

                 JCO.addClientPool(PoolName, 		    // Alias for this pool
                 300, 		            // Max. number of connections
                 "700",		            // SAP client 
                 "oemrfc",              // userid  rfcorder
                 "basis",	            // password  init
                 "KO",   	            // language
                 "165.244.235.84",      // host name (Ip Address)
                 "10");                 // system no.

                 writeToFile("zconnect = 700 165.244.235.84 10" );



                 JCO.addClientPool(PoolName, 		    // Alias for this pool
                 300, 		            // Max. number of connections
                 "510",		            // SAP client 
                 "oemrfc",              // userid  rfcorder oemrfc
                 "basis",	            // password  init  basis
                 "KO",   	            // language
                 "165.244.235.84",      // host name (Ip Address) 165.244.235.84
                 "10");                 // system no.10

                 Logger.debug("zconnect = 510 165.244.235.84 10" );

                 JCO.addClientPool(PoolName, 		// Alias for this pool
                 300, 		               // Max. number of connections
                 "700",		               // SAP client 
                 "traumrfc",               // userid  rfcorder
                 "lgcns",	               // password  init
                 "KO",   	               // language
                 "165.244.235.84",         // host name 
                 "10");                    // system no.

                 통합 SAP 테스트 환경 
                 */


//                //------------------------ 해외법인 접속정보 FROM PPT FILE ----------------------
//                해외법인개발      165.244.235.84  DEVMM01/DEVMM01 Eghpark /qkrrms  OPEN  / RFCOPEN
//                해외법인 운영 165.244.235.119 Batchsd / sdpwd01   OPEN  / RFCOPEN
//                국내 개발환경 165.244.235.81  e-junhokim /park1028    OPEN  
//                국내 운영환경 165.244.235.102 e-junhokim /park1028    OPEN

//                //------------------------------------------------------------------------------
//                //해외법인 개발
//                //------------------------------------------------------------------------------
//                <sap>
//                <spec name="default">
//                  <sap-client>310</sap-client>     
//                  <user-id>OPEN</user-id>
//                  <password>RFCOPEN</password>
//                  <language>KO</language>
//                  <host-name>165.244.245.84</host-name> <!--Dev server-->
//                  <!--<host-name>165.244.235.119</host-name>--> <!--Prodserver-->
//                  <system-no>01</system-no>    
//                </spec>
//              </sap>
                
                //edit+++
                //구매지원 해외확산
                //public static void addClientPool(String key, int max_connections, String client, String user, String passwd, String lang, String ashost, String sysnr)
                JCO.addClientPool(PoolName, 300, "310", "DEVMM01", "DEVMM01", "KO", "165.244.245.84", "01");
              
                //old+++
                //JCO.addClientPool(PoolName, 300, "100", "oemrfc", "LGCNS1", "KO", "165.244.235.102", "PRD", "PRDALL");

            }

            JCOClient = JCO.getClient(PoolName);

            mRepository = new JCO.Repository("MYRepository", JCOClient);

            //			Logger.debug("mRepository=="+mRepository);
        } catch (JCO.Exception ex) {
            writeToFile("Caught an exception: \n" + ex);

        }
        return mRepository;
    }

    public JCO.Client get_client(){
        return JCOClient;
    }

    public void releaseClient(){
        JCO.releaseClient(JCOClient);
        writeToFile("release SAP Connection : " + PoolName);
    }

    // connection 반납
    public void retPool(){
        try {
            // return a connection pool to the specified system
            JCO.removeClientPool("sappool");
        } catch (JCO.Exception ex) {
            writeToFile("Caught an exception: \n" + ex);
        }
    }

    protected void executeFunction(JCO.Function function){
        try {
            synchronized (JCOClient) {
                JCOClient.execute(function);
            }

        } catch (JCO.Exception ex) {
            writeToFile("<<JcoComm.executeFunction()>> Catch JCO.Exception :->" + ex.toString());
        } catch (Exception e) {
            writeToFile("<<JcoComm.executeFunction()>> Catch Exception :->" + e.toString());
        } finally {
            //			if(JCOClient != null)
            JCO.releaseClient(JCOClient);
            //				Logger.debug("release SAP Connection 111: "+PoolName);
        }

    }

}
