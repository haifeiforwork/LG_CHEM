package hris.N;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;

import java.util.HashMap;
import java.util.Vector;

public class EHRComCRUDInterfaceRFC  extends SAPWrap{

     /**
      *
      *  2015-05-21
      *  ��� RFC ��ȸ -  ���ϰ� ���� �ϴ� �޼ҵ� structure �� table ��� ��ȸ
	  *
      * @return java.util.Vector
      * @return
      */
     public Vector getExecuteReturnData(Box boxData, String functionName) throws GeneralException {

         JCO.Client mConnection = null;
         try{
             mConnection = getClient();
             JCO.Function function = createFunction(functionName);
             EHRSAPWrap.setFieldForLMultiData(function, boxData);
             excute(mConnection, function);
             Vector lData = EHRSAPWrap.getAllStruture(function);
//             String reCode = EHRSAPWrap.getReturnMessage(lData);
//             lData.put("reCode", reCode);
             return lData;
         } catch(Exception ex) {
             //Log.err.println(this.getClass().getName() + ".getExecuteReturnData() Exception : " + ex.getMessage());
             Logger.error(ex);
             throw new GeneralException(ex.toString());
         } finally {
             close(mConnection);
         }
     }

     /**
      * 2015-02-21
      * structure or table ��ȸ�� �����ؼ� ��� ��ȸ
      * RETURN �� ������ ���� �Ǿ� �ִ�. structure �� ���� �Ǿ������ �޼ҵ� �и� ��
      *
      *
      * @param boxData
      * @param functionName
      * @param stGubun
      * @return
      * @throws GeneralException
      */
     public HashMap getReturnST(Box boxData, String functionName, String stGubun) throws GeneralException {
    	 HashMap lData = null;
         JCO.Client mConnection = null;
         try{
             mConnection = getClient();
             JCO.Function function = createFunction(functionName);
             EHRSAPWrap.setFieldForLMultiData(function, boxData);
             excute(mConnection, function);
//             String returnCode = getField("RETURN",function);
             String returnCode = getField("E_RETURN",function);

             //Logger.debug("returnCode " + returnCode);

             if(stGubun.equals("T")){
            	  lData = EHRSAPWrap.getAllExportTable(function);
            	  //Logger.debug("returnCode lData " + lData);
             }else{
            	  lData = EHRSAPWrap.getAllExportParameter(function);
            	  lData.put("returnCode", getReturn().MSGTY);

             }

             return lData;
         } catch(Exception ex) {
             Logger.error(ex);
             throw new GeneralException(ex.toString());
         } finally {
             close(mConnection);
         }
     }

     /**
      * 2015-06-15 marco257
      * ��� table��ȸ Exportd�� Field�� �Ѱ� ������� ����Ѵ�.
      * @param boxData
      * @param functionName
      * @param fieldName
      * @return
      * @throws GeneralException
      */

    public HashMap getExecutAllTable(Box boxData, String functionName, String fieldName) throws GeneralException {

         JCO.Client mConnection = null;
         try{
             mConnection = getClient();
             JCO.Function function = createFunction(functionName);
             EHRSAPWrap.setFieldForLMultiData(function, boxData);
             excute(mConnection, function);
             HashMap lData = EHRSAPWrap.getAllExportTable(function);
             if(!fieldName.equals("")){
	             String ORGTX = getField(fieldName,function);
	             lData.put(fieldName,ORGTX);
             }

             return lData;
         } catch(Exception e) {
             Logger.error(e);
             throw new GeneralException(e.toString());
         } finally {
             close(mConnection);
         }
     }

    /**
     * 2015-10-06 marco
     * ��� table��ȸ Export�� Field���� ������ ��� ����Ѵ�.
     * @param boxData
     * @param functionName
     * @return
     * @throws GeneralException
     */
    public HashMap getExecutAll(Box boxData, String functionName) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            EHRSAPWrap.setFieldForLMultiData(function, boxData);
            excute(mConnection, function);

            HashMap lData = EHRSAPWrap.getAllExportTable(function);
            lData.put("EXPORT_FIELD",EHRSAPWrap.getExportParameter(function));

            return lData;
        } catch(Exception ex) {
            Logger.error(ex);
            throw new GeneralException(ex.toString());
        } finally {
            close(mConnection);
        }
    }


     /**
      *
      * 2015-05-29
      *
      * import�� structure�� �������,  LongText Table�� �������  ó���ϴ�method.
      * ����) �ǰ�, �ɸ� ���� ��û ���Ϻ����⿡ �����.
      * @param boxData
      * @param functionName
      * @return
      * @throws GeneralException
      */
	 public String setImportTableData(Box boxData, String functionName, Vector TextVT, String tabletName) throws GeneralException {

		 	JCO.Client mConnection = null;
	   try{
	       mConnection = getClient();
	       JCO.Function function = createFunction(functionName);
	       EHRSAPWrap.setFieldForLMultiData(function, boxData);
	       //import �ĸ������� structure ����
	       EHRSAPWrap.setImportStructureMultiData(function, boxData, tabletName);
	       EHRSAPWrap.setInsertTable(function, TextVT, "T_TEXT","LINE");
	       excute(mConnection, function);
	       String returnCode = getField("E_RETURN",function); //RETURN
	       return returnCode;
	   } catch(Exception ex) {
		   Logger.error(ex);
           throw new GeneralException(ex.toString());
	   } finally {
	       close(mConnection);
	   }
	 }


	/**
	 * 2015-06-19
	 * ��� : �����ٷα� /
	 * import ������ insert
	 * @param functionName
	 * @return
	 * @throws GeneralException
	 */
   public String setImportInsert(Box boxData, String functionName, String fieldName) throws GeneralException {
	   String retCode = "";
	   JCO.Client mConnection = null;
	   try{
	       mConnection = getClient();
	       JCO.Function function = createFunction(functionName);
	       EHRSAPWrap.setFieldForLMultiData(function, boxData);
	       excute(mConnection, function);
	      retCode = getField(fieldName,function);
	       return retCode;
	   }catch(Exception ex) {
		   Logger.error(ex);
           throw new GeneralException(ex.toString());
	   } finally {
	       close(mConnection);
	   }
	 }

   /**
    * Table�� insert�Ұ�� ó��
    * @param boxData
    * @param functionName
    * @return
    * @throws GeneralException
    */
   public String setTableInsert(Box boxData, String functionName, Vector dataVT, String tableName) throws GeneralException {
       JCO.Client mConnection = null;
       try{
           mConnection = getClient();
           JCO.Function function = createFunction(functionName) ;
           EHRSAPWrap.setFieldForLMultiData(function, boxData);
           setTable(function, tableName, dataVT);
           excute(mConnection, function);
           String returnCode = getField("RETURN",function);
	       return returnCode;

       } catch(Exception ex){
           //Logger.sap.println(this, "SAPException : "+ex.toString());
           throw new GeneralException(ex);
       } finally {
           close(mConnection);
       }
   }


   public HashMap setExecutGetData(Box boxData, String functionName, Vector dataVT, String tableName) throws GeneralException {
	   JCO.Client mConnection = null;
       try{
           mConnection = getClient();
           JCO.Function function = createFunction(functionName) ;
           EHRSAPWrap.setFieldForLMultiData(function, boxData);
           setTable(function, tableName, dataVT);
           excute(mConnection, function);
           HashMap lData = EHRSAPWrap.getAllExportTable(function);
           return lData;
       } catch(Exception ex){
           //Logger.sap.println(this, "SAPException : "+ex.toString());
           throw new GeneralException(ex);
       } finally {
           close(mConnection);
       }
   }




//	public String exeTableInsertData(Box boxData, String functionName,String tableName, String reTable) throws GeneralException {
//  	JCO.Client mConnection = null;
//      try{
//      	mConnection = getClient();
//          JCO.Function function = createFunction(functionName) ;
//          EHRSAPWrap.setFieldForLMultiData(function, boxData);
//          EHRSAPWrap.setTableForLMultiData(function, boxData, tableName);
//          excute(mConnection, function);
//          String e_return = this.getReturnMessage(function, reTable);
//          return e_return;
//      } catch(Exception ex) {
//          LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//          throw new LSysException(ex.toString());
//      } finally {
//          close(mConnection);
//      }
//  }
//
     /**
      * ���� ó�� ���� ���̺��� �ٸ� ��� ó��
      * METHODS
      * @param lMultiData
      * @param functionName
      * @param reTable
      * @return
      * @throws GeneralException
      */
//     public LData getExecuteReturnData(LMultiData lMultiData, String functionName, String reTable) throws GeneralException {
//
//         JCO.Client mConnection = null;
//         try{
//             mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName);
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             String e_return = this.getReturnMessage(function, reTable);
//             lData.put("reCode", e_return);
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".getExecuteReturnData() Exception : " + ex.getMessage());
//             Logger.error(e);
//             throw new SAPException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
     /**
      *
      * METHODS
      * @param lMultiData
      * @param functionName
      * @return
      * @throws GeneralException
      */
//     public LData setExecuteReturnData(LMultiData lMultiData, String functionName) throws GeneralException {
//
//         JCO.Client mConnection = null;
//         try{
//             mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName);
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             String reCode = EHRSAPWrap.getReturnMessage(lData);
//             lData.put("reCode", reCode);
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".setExecuteReturnData() Exception : " + ex.getMessage());
//             Logger.error(e);
//             throw new SAPException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }



     /**
      *
      * METHODS
      * @param lMultiData
      * @param functionName
      * @return
      * @throws GeneralException
      */
//     public LData setExecuteEReturnData(LMultiData lMultiData, String functionName) throws GeneralException {
//
//         JCO.Client mConnection = null;
//         try{
//             mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName);
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             String reCode = EHRSAPWrap.getEReturnEMessage(lData);
//             lData.put("reCode", reCode);
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".setExecuteReturnData() Exception : " + ex.getMessage());
//             Logger.error(e);
//             throw new SAPException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }

//     public LData setExecuteEReturnData(LMultiData lMultiData, String functionName,String tableName) throws GeneralException {
//
//         JCO.Client mConnection = null;
//         try{
//              mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName);
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             String reCode = EHRSAPWrap.getEReturnEMessage(lData);
//             lData.put("reCode", reCode);
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".setExecuteReturnData() Exception : " + ex.getMessage());
//             Logger.error(e);
//             throw new SAPException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//
//     public LData setExecuteENoReturnData(LMultiData lMultiData, LMultiData lMultiData2,String functionName,String tName, String tName2) throws GeneralException {
//
//         JCO.Client mConnection = null;
//         try{
//             mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName);
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             //EHRSAPWrap.setTableForLMultiData(function, lMultiData);
//             EHRSAPWrap.setMultiTableForLMultiData(function, lMultiData,lMultiData2,tName,tName2);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             excute(mConnection, function);
//
//             return lData;
//
//
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".setExecuteReturnData() Exception : " + ex.getMessage());
//             Logger.error(e);
//             throw new SAPException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }

     /**
      * 2013-08-08
      * METHODS
      * @param parmData
      * @param realData
      * @param functionName
      * @param tName
      * @return
      * @throws GeneralException
      */
//     public LData setExecuteReturnData(LMultiData parmData, LMultiData realData,String functionName,String tName, String reTable) throws GeneralException {
//
//         JCO.Client mConnection = null;
//         try{
//             mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName);
//             EHRSAPWrap.setFieldForLMultiData(function, parmData);
//
//             EHRSAPWrap.setTableForLMultiData(function, realData, tName);
//             LData reData = EHRSAPWrap.getAllStruture(function);
//             excute(mConnection, function);
//             String e_return = this.getReturnMessage(function, reTable);
//             reData.put("reCode",e_return);
//             return reData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".setExecuteReturnData() Exception : " + ex.getMessage());
//             Logger.error(e);
//             throw new SAPException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//
//

     /**
      * ����� ����
      * �Ϲ� Table
      * ���̺���� ���� �Ǿ� �ִ�.
      * @param lMultiData
      * @param famevt
      * @param functionName
      * @return
      * @throws LException
      */
//  	public String exeOneTableInsertData(LMultiData lMultiData, String functionName) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             EHRSAPWrap.setTableForLMultiData(function, lMultiData, "T_EXPORTA");
//             excute(mConnection, function);
//             String e_return = this.getReturnMessage(function, "RETURN");
//             return e_return;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//  	public String exeTableInsertData(LMultiData lMultiData, String functionName,String tableName, String reTable) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             EHRSAPWrap.setTableForLMultiData(function, lMultiData, tableName);
//             excute(mConnection, function);
//             String e_return = this.getReturnMessage(function, reTable);
//             return e_return;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//
//	public LData exeTableInsertData(LMultiData lMultiData, String functionName,String tableName) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             EHRSAPWrap.setTableForLMultiData(function, lMultiData, tableName);
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             //Logger.debug("lData >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ lData);
//
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//
//
//	public LData exeTableInsertData(LMultiData lMultiData, LMultiData lMultiData2, String functionName,String tableName, String tableName2) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//             EHRSAPWrap.setTableForLMultiData(function, lMultiData, tableName2);
//             EHRSAPWrap.setTableForLMultiData(function, lMultiData2, tableName);
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             //Logger.debug("lData >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ lData);
//
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }

	/**
	 * ��ī��Ʈ ������Ȳ ��ȸ���� ���
	 * 2013-09-25
	 * METHODS
	 * @param lMultiData
	 * @param lMultiData2
	 * @param functionName
	 * @param tableName
	 * @param tableName2
	 * @return
	 * @throws LException
	 */
//	public LData exeTableApplyData(LMultiData P,LMultiData D1, LMultiData D2, LMultiData D3, String functionName,String t1, String t2, String t3) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, P);
//             EHRSAPWrap.setTableForLMultiData(function, D1, t1);
//             EHRSAPWrap.setTableForLMultiData(function, D2, t2);
//             EHRSAPWrap.setTableForLMultiData(function, D3, t3);
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             //Logger.debug("lData >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ lData);
//
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
	/**
	 * ���̺� 2���� range������
	 * METHODS
	 * @param P
	 * @param D1
	 * @param D2
	 * @param functionName
	 * @param t1
	 * @param t2
	 * @return
	 * @throws LException
	 */
//	public LData exeTwoTableData(LMultiData P,LMultiData D1, LMultiData D2, String functionName,String t1, String t2,String reTable) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, P);
//             EHRSAPWrap.setTableForLMultiData(function, D1, t1);
//             EHRSAPWrap.setTableForLMultiData(function, D2, t2);
//
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             //Logger.debug("lData >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ lData);
//             String e_return = this.getReturnMessage(function, reTable);
//             lData.put("reCode",e_return);
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//
//	public LData exeTableApplyData(LMultiData P,LMultiData D1, LMultiData D2, LMultiData D3,LMultiData D4,LMultiData D5,LMultiData D6, String functionName,String t1, String t2, String t3, String t4, String t5, String t6) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, P);
//             EHRSAPWrap.setTableForLMultiData(function, D1, t1);
//             EHRSAPWrap.setTableForLMultiData(function, D2, t2);
//             EHRSAPWrap.setTableForLMultiData(function, D3, t3);
//             EHRSAPWrap.setTableForLMultiData(function, D4, t4);
//             EHRSAPWrap.setTableForLMultiData(function, D5, t5);
//             EHRSAPWrap.setTableForLMultiData(function, D6, t6);
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             //Logger.debug("lData >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ lData);
//
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//
//	public LData exeTableApplyData(LMultiData P,LMultiData D1, LMultiData D2, String functionName,String t1, String t2) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, P);
//             EHRSAPWrap.setTableForLMultiData(function, D1, t1);
//             EHRSAPWrap.setTableForLMultiData(function, D2, t2);
//
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//            // Logger.debug("lData >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ lData);
//
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//
//
//	public LData exeTableApplyData(LMultiData P,LMultiData D, String functionName,String t) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, P);
//             EHRSAPWrap.setTableForLMultiData(function, D, t);
//
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//
//
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }
//
//	 public LData exeTableApplyData(LMultiData P,LMultiData D, String functionName,String t,String reTable) throws LException {
//     	JCO.Client mConnection = null;
//         try{
//         	mConnection = getClient(langType);
//             JCO.Function function = createFunction(functionName) ;
//             EHRSAPWrap.setFieldForLMultiData(function, P);
//             EHRSAPWrap.setTableForLMultiData(function, D, t);
//
//             excute(mConnection, function);
//             LData lData = EHRSAPWrap.getAllStruture(function);
//             String e_return = this.getReturnMessage(function, reTable);
//             lData.put("reCode",e_return);
//
//             return lData;
//         } catch(Exception ex) {
//             LLog.err.println(this.getClass().getName() + ".exeOneTableInsertData() Exception : " + ex.getMessage());
//             throw new LSysException(ex.toString());
//         } finally {
//             close(mConnection);
//         }
//     }

    /**
     * ����� ����
     * �Ϲ� Table�� textArea�� ������ Table
     * ���̺���� ���� �Ǿ� �ִ�.(�⺻������ 1�� Ȥ�� 2��)
     * T_EXPORTA, crudCheck= Y �� ��� T_EXPORTB
     * crudCheck= Y �̸� �Ϲ������� TextArea���
     * pub.acceptregist��� ��
     * @param lMultiData
     * @param famevt
     * @param functionName
     * @return
     * @throws LException
     */
// 	public String executeCboInsertData(LMultiData lMultiData, Vector famevt, String functionName,String crudCheck) throws LException {
//    	JCO.Client mConnection = null;
//        try{
//        	mConnection = getClient(langType);
//            JCO.Function function = createFunction(functionName) ;
//            EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//            EHRSAPWrap.setTableForLMultiData(function, lMultiData, "T_EXPORTA");
//            if(crudCheck.equals("Y")){
//            	setTable(function, "T_EXPORTB", famevt);
//            }
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, "RETURN");
//            return e_return;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".executeCboInsertData() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
//
//	/**
//	 *
//	 * �Ϲ� ���̺��� ������ �� ��� �ѹ��� insert or update
//	 * @param lMultiData
//	 * @param functionName
//	 * @param tableNameVt
//	 * @return
//	 * @throws LException
//	 */
// 	public String executeCboInsertMultData(LMultiData lMultiData, String functionName, Vector tableNameVt) throws LException {
//    	JCO.Client mConnection = null;
//    	int tSize = 0;
//    	String tName ="";
//        try{
//        	if(tableNameVt != null){
//        		tSize = tableNameVt.size();
//        	}
//        	 mConnection = getClient(langType);
//            JCO.Function function = createFunction(functionName) ;
//            EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//            if(tSize > 0){
//    	    	for(int t = 0 ; t < tSize ; t ++){
//    	    		tName = (String)tableNameVt.get(t);
//    	    		EHRSAPWrap.setTableForLMultiData(function, lMultiData, tName);
//    	    	}
//        	}
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, "RETURN");
//            return e_return;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".executeCboInsertMultData() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
//
//
// 	public String executeCboInsertMultData(LMultiData lMultiData, String functionName, Vector tableNameVt, String reName) throws LException {
//    	JCO.Client mConnection = null;
//    	int tSize = 0;
//    	String tName ="";
//        try{
//        	if(tableNameVt != null){
//        		tSize = tableNameVt.size();
//        	}
//        	 mConnection = getClient(langType);
//            JCO.Function function = createFunction(functionName) ;
//            EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//            if(tSize > 0){
//    	    	for(int t = 0 ; t < tSize ; t ++){
//    	    		tName = (String)tableNameVt.get(t);
//    	    		EHRSAPWrap.setTableForLMultiData(function, lMultiData, tName);
//    	    	}
//        	}
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, reName);
//            return e_return;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".executeCboInsertMultData() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
//
//	/**
//	 * ���Ŀ� �Ϲ� ���̺� Ȥ�� TextArea�� ������ ���̺��� �Ѳ����� ó���ϴ� ���� �߰�
//	 * ���͸� ������ �����͸� ���� �Ѵ�.
//	 * ���̺���� Ȯ�ǽ� �ɰ��.
//	 *
//        Hashtable ht = new Hashtable();
//        Vector vt = new Vector();
//        vt.add("vt1-1");
//        vt.add("vt1-2");
//
//        Vector vt2 = new Vector();
//        vt2.add("vt2-1");
//        vt2.add("vt2-2");
//
//        ht.put("line0",vt );
//        ht.put("line1",vt2 );
//
//        //���̺�� : Hashtable�� size ������ ����!!
//        Vector tablVT = new Vector();
//        tablVT.add("T_EXPORTA");
//        tablVT.add("T_EXPORTB");
//
//        for(int i = 0 ; i <ht.size(); i++ ){
//        	String tableName =(String)tablVT.get(i);
//        	Vector vtobj = (Vector)ht.get("line"+i);
//        	if(vtobj instanceof java.util.Vector){
//        		setTable(function, tableName, vtobj); �߰�
//        		Logger.debug(tableName);
//        	}
//        }
//
//     tableLine    => Vector(Data��ü)�� ������ Hashtable
//     tableNameLvt =>  TextArea�� ������ Table �̸�
//     tableNameNvt => �Ϲ����� Table �̸�
//	 * @param lMultiData
//	 * @param functionName
//	 * @param tableNameVt
//	 * @return
//	 * @throws LException
//	 */
// 	public String exeInsertMultTLineData(LMultiData lMultiData, String functionName, Hashtable tableLine, Vector tableNameLvt, Vector tableNameNvt) throws LException {
//    	JCO.Client mConnection = null;
//    	int tSizeL  = 0;
//    	int tSizeN  = 0;
//    	String tNameL ="";
//    	String tNameN ="";
//
//        try{
//        	if(tableNameLvt != null){
//        		tSizeL = tableNameLvt.size();
//        	}
//        	if(tableNameNvt != null){
//        		tSizeN = tableNameNvt.size();
//
//        	}
//        	 mConnection = getClient(langType);
//            JCO.Function function = createFunction(functionName) ;
//            EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//
//            /**
//             * �Ϲ����� �������� ���
//             */
//            if(tSizeN > 0){
//    	    	for(int t = 0 ; t < tSizeN ; t ++){
//    	    		tNameN = (String)tableNameNvt.get(t);
//    	    		EHRSAPWrap.setTableForLMultiData(function, lMultiData, tNameN);
//    	    	}
//        	}
//            /**
//             * TextArea �������� ���
//             */
//            if(tSizeL > 0){
//            	 for(int i = 0 ; i <tSizeL ; i++ ){
//            		tNameL =(String)tableNameLvt.get(i);
//                 	Vector vtobj = (Vector)tableLine.get("line"+i);
//                 	if(vtobj instanceof java.util.Vector){
//                 		setTable(function, tNameL, vtobj); //�߰�
//                 	}
//                 }
//        	}
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, "RETURN");
//            return e_return;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".exeInsertMultTLineData() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
// 	/**
// 	 * �߱� �ֹ� ��ȣ üũ ����
// 	 * METHODS
// 	 * @param lMultiData
// 	 * @param famevt
// 	 * @param functionName
// 	 * @param crudCheck
// 	 * @return
// 	 * @throws LException
// 	 */
//	public String execIDNUMCheck(LData lData) throws LException {
//    	JCO.Client mConnection = null;
//        try{
//        	mConnection = getClient(langType);
//            JCO.Function function = createFunction("ZHR002_ESS_ICNUM_CHECK") ;
//            EHRSAPWrap.setFieldForLData(function, lData);
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, "RETURN");
//            return e_return;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".execIDNUMCheck() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
//
// 	public String executeCboInsertData(LMultiData lMultiData, String functionName,String tableName) throws LException {
//    	JCO.Client mConnection = null;
//        try{
//        	mConnection = getClient(langType);
//            JCO.Function function = createFunction(functionName) ;
//            EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//            EHRSAPWrap.setTableForLMultiData(function, lMultiData, tableName);
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, "RETURN");
//            return e_return;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".executeCboInsertData() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
// 	/**
// 	 * ���� ���� ó�� ���� ����
// 	 * @param lMultiData
// 	 * @param functionName
// 	 * @param tableName1
// 	 * @param tableName2
// 	 * @return
// 	 * @throws LException
// 	 */
// 	public String setApplTableInsertData(LMultiData lMultiData, String functionName, Vector appline) throws LException {
//    	JCO.Client mConnection = null;
//        try{
//        	mConnection = getClient(langType);
//            JCO.Function function = createFunction(functionName) ;
//            EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//            setTable(function, "T_EXPORTA", appline);
//            EHRSAPWrap.setStructureMultiData(function, lMultiData, "T_EXPORTB");
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, "RETURN");
//            return e_return;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".setApplTableInsertData() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
// 	/**
// 	 * lMultiData �߿� ù��° �ο츸 ���� �Ѵ�.
// 	 * @param lMultiData
// 	 * @param functionName
// 	 * @param tableName1
// 	 * @param tableName2
// 	 * @return
// 	 * @throws LException
// 	 */
// 	public String setApplOneRowInsertData(LMultiData lMultiData, String functionName,String tableName) throws LException {
//    	JCO.Client mConnection = null;
//        try{
//        	mConnection = getClient(langType);
//            JCO.Function function = createFunction(functionName) ;
//            EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//            EHRSAPWrap.setImportStructureMultiData(function, lMultiData, tableName);
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, "RETURN");
//            return e_return;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".setApplOneRowInsertData() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
//
// 	/**
// 	 * TextArea ����
// 	 * METHODS
// 	 * @param mdata
// 	 * @param edu_vt
// 	 * @param gubun
// 	 * @param functionName
// 	 * @return
// 	 * @throws LException
// 	 */
//	public String setTextAreaCRUD(LMultiData mdata, Vector temp_vt, String gubun, String functionName) throws LException {
//    	JCO.Client mConnection = null;
//        String reStr ="";
//
//        try{
//        	mConnection = getClient(langType);
//            JCO.Function function = createFunction(functionName) ;
//            EHRSAPWrap.setFieldForLMultiData(function, mdata);
//            EHRSAPWrap.setTableForLMultiData(function,mdata,"T_EXPORTA");
//            if(gubun.equals("M")){ //������ ���
//            	setTable(function, "T_EXPORTB", temp_vt);
//            }
//            excute(mConnection, function);
//            String e_return = this.getReturnMessage(function, "RETURN");
//            if (e_return.equals("S")){
//            	reStr = "S";
//			} else {
//				reStr = e_return;
//			}
//            return reStr;
//        } catch(Exception ex) {
//            LLog.err.println(this.getClass().getName() + ".setEduCRUD() Exception : " + ex.getMessage());
//            throw new LSysException(ex.toString());
//        } finally {
//            close(mConnection);
//        }
//    }
}
