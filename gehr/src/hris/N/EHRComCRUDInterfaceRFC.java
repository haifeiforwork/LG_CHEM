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
      *  모든 RFC 조회 -  리턴값 포함 하는 메소드 structure 와 table 모두 조회
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
      * structure or table 조회를 구분해서 결과 조회
      * RETURN 이 변수로 정의 되어 있다. structure 로 정의 되었을경우 메소드 분리 예
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
      * 모든 table조회 Exportd의 Field가 한개 있을경우 사용한다.
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
     * 모든 table조회 Export의 Field값이 다중일 경우 사용한다.
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
      * import에 structure가 있을경우,  LongText Table이 있을경우  처리하는method.
      * 참고) 건강, 심리 상태 신청 메일보내기에 사용함.
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
	       //import 파리미터의 structure 셋팅
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
	 * 사용 : 웹접근로그 /
	 * import 값에만 insert
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
    * Table에 insert할경우 처리
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
      * 에러 처리 리턴 테이블이 다를 경우 처리
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
      * 저장및 수정
      * 일반 Table
      * 테이블명이 고정 되어 있다.
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
	 * 스카우트 지원현황 조회에서 사용
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
	 * 테이블 2개의 range변수값
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
     * 저장및 수정
     * 일반 Table과 textArea를 포함한 Table
     * 테이블명이 고정 되어 있다.(기본적으로 1나 혹은 2개)
     * T_EXPORTA, crudCheck= Y 일 경우 T_EXPORTB
     * crudCheck= Y 이면 일반적으로 TextArea사용
     * pub.acceptregist사용 예
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
//	 * 일반 테이블이 여러개 일 경우 한번에 insert or update
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
//	 * 추후에 일반 테이블 혹은 TextArea을 포함한 테이블을 한꺼번에 처리하는 로직 추가
//	 * 벡터를 포함한 데이터만 가공 한다.
//	 * 테이블명이 확실시 될경우.
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
//        //테이블명 : Hashtable과 size 같도록 주의!!
//        Vector tablVT = new Vector();
//        tablVT.add("T_EXPORTA");
//        tablVT.add("T_EXPORTB");
//
//        for(int i = 0 ; i <ht.size(); i++ ){
//        	String tableName =(String)tablVT.get(i);
//        	Vector vtobj = (Vector)ht.get("line"+i);
//        	if(vtobj instanceof java.util.Vector){
//        		setTable(function, tableName, vtobj); 추가
//        		Logger.debug(tableName);
//        	}
//        }
//
//     tableLine    => Vector(Data객체)를 포함한 Hashtable
//     tableNameLvt =>  TextArea를 포함한 Table 이름
//     tableNameNvt => 일반적인 Table 이름
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
//             * 일반적인 데이터일 경우
//             */
//            if(tSizeN > 0){
//    	    	for(int t = 0 ; t < tSizeN ; t ++){
//    	    		tNameN = (String)tableNameNvt.get(t);
//    	    		EHRSAPWrap.setTableForLMultiData(function, lMultiData, tNameN);
//    	    	}
//        	}
//            /**
//             * TextArea 데이터일 경우
//             */
//            if(tSizeL > 0){
//            	 for(int i = 0 ; i <tSizeL ; i++ ){
//            		tNameL =(String)tableNameLvt.get(i);
//                 	Vector vtobj = (Vector)tableLine.get("line"+i);
//                 	if(vtobj instanceof java.util.Vector){
//                 		setTable(function, tNameL, vtobj); //추가
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
// 	 * 중국 주민 번호 체크 로직
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
// 	 * 결제 라인 처리 공통 로직
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
// 	 * lMultiData 중에 첫번째 로우만 저장 한다.
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
// 	 * TextArea 저장
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
//            if(gubun.equals("M")){ //수정일 경우
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
