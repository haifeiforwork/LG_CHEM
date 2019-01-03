package com.sns.jdf.mobile;

/** jdom을 이용하여 XML 생성을 위한 Util 이다 */
public class MobileCodeErrVO {

    // 공통
    public static String ERROR_CODE_000 = "000";
    public static String ERROR_MSG_000 = "요청한 문서의 정보가 존재하지 않습니다.";

    public static String ERROR_CODE_010 = "010";
    public static String ERROR_MSG_010 = "필요한 인자값이 존재하지 않습니다.";

    // 상세보기
    public static String ERROR_CODE_100 = "100";
    public static String ERROR_MSG_100 = "해당 문서는 모바일결재 대상이 아닙니다.";

    public static String ERROR_CODE_200 = "200";
    public static String ERROR_MSG_200 = "권한:";

    // 결재처리
    public static String ERROR_CODE_300 = "300";
    public static String ERROR_MSG_300 = "결재처리관련: ";

    // 통합결재연동관련
    public static String ERROR_CODE_400 = "400";
    public static String ERROR_MSG_400 = "통합결재연동관련: ";

    // 휴가신청
    public static String ERROR_CODE_500 = "500";
    public static String ERROR_MSG_500 = "휴가신청: ";

    // 초과근무신청
    public static String ERROR_CODE_600 = "600";
    public static String ERROR_MSG_600 = "초과근무신청: ";

    // 초과근무 사후신청
    public static String ERROR_CODE_700 = "700";
    public static String ERROR_MSG_700 = "초과근무 사후신청: ";

    // Flextime 신청
    public static String ERROR_CODE_800 = "800";
    public static String ERROR_MSG_800 = "Flextime 신청: ";

    public static String ERROR_CODE_999 = "999";
    public static String ERROR_MSG_999 = "예기치 못한 오류가 발생하였습니다.\\n 담당자에게 문의 바랍니다.";

}