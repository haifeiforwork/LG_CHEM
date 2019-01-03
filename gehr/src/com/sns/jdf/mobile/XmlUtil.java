package com.sns.jdf.mobile;

import org.apache.commons.lang.StringUtils;
import org.jdom.CDATA;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Namespace;
import org.jdom.output.XMLOutputter;

/** jdom을 이용하여 XML 생성을 위한 Util 이다 */
public class XmlUtil {

    /**
     * XMLDocument를 XML String 으로 가져온다.
     * 
     * @param document
     * @return XML String
     */
    public static String convertString(Document document) {
        XMLOutputter outputter = new XMLOutputter();
        return outputter.outputString(document);
    }

    /**
     * XML Root를 생성한다.
     * <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
     * 
     * @return
     */
    public static Element createEnvelope() {
        Element envelop = new Element("Envelope", "soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
        Namespace ns1 = Namespace.getNamespace("xsd", "http://www.w3.org/2001/XMLSchema");
        Namespace ns2 = Namespace.getNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");
        envelop.addNamespaceDeclaration(ns1);
        envelop.addNamespaceDeclaration(ns2);
        return envelop;
    }

    /**
     * Body XML을 생성한다.
     * <soapenv:Body>
     * 
     * @return
     */
    public static Element createBody() {
        Element body = new Element("Body", "soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
        return body;
    }

    /**
     * WAT_RESPONSE XML을 생성한다.
     * 
     * @return
     */
    public static Element createWaitResponse() {
        Element waitResponse = new Element("WAT_RESPONSE");
        Namespace ns = Namespace.getNamespace("http://ws.approval.lgchem.com");
        waitResponse.setNamespace(ns);
        return waitResponse;
    }

    /**
     * Itesms Elements를 생성한다.
     * 
     * @param elementName
     * @return
     */
    public static Element createItems(String elementName) {
        Element items = new Element(elementName);
        items.setNamespace(Namespace.NO_NAMESPACE);
        return items;

    }

    /**
     * XML Root를 생성한다.
     * 
     * @param rootElementName 최상위 element 이름
     * @param nameSpace xsi namespece
     * @param noNameSpace noNamespaceSchemaLocation
     * @return
     */
    public static Element createXmlDocuemnt(String rootElementName) {
        return createXmlDocuemnt(rootElementName, null, null);
    }

    /**
     * XML Root를 생성한다.
     * 
     * @param rootElementName 최상위 element 이름
     * @param nameSpace xsi namespece
     * @param noNameSpace noNamespaceSchemaLocation
     * @return
     */
    public static Element createXmlDocuemnt(String rootElementName, String nameSpace, String noNameSpace) {
        Element rootElement = new Element(rootElementName, Namespace.NO_NAMESPACE);

        if (nameSpace != null) {
            Namespace namespace = Namespace.getNamespace("xsi", nameSpace);
            if (noNameSpace != null) {
                rootElement.setAttribute("noNamespaceSchemaLocation", noNameSpace, namespace);
            } else {
                rootElement.setNamespace(namespace);
            }
        }
        return rootElement;
    }

    /**
     * XML Element를 생성한다.
     * 
     * @param elementName 엘리먼트 이름
     * @return element
     */
    public static Element createElement(String elementName) {
        return createElement(elementName, null, true);
    }

    /**
     * XML Element를 생성한다.
     * ex)<appId>APPID001</appId>
     * 
     * @param elementName 엘리먼트 이름
     * @param elementValue 엘리먼트 명
     * @return element
     */
    public static Element createElement(String elementName, String elementValue) {
        return createElement(elementName, elementValue, true);
    }

    /**
     * XML Element를 생성한다.
     * ex)<appId>APPID001</appId>
     * 
     * @param elementName 이름
     * @param elementValue 값
     * @param isCDATA CDATA 여부
     * @return element
     */
    public static Element createElement(String elementName, String elementValue, boolean isCDATA) {
        Element element = new Element(elementName);
        if (isCDATA) {
            element.addContent(new CDATA(elementValue));
        } else {
            element.addContent(elementValue);
        }
        return element;
    }

    /**
     * element에 child element를생성한다.
     * 
     * @param element 엘리먼트
     * @param elementName 이름
     * @param elementValue 값
     * @return
     */
    public static void addChildElement(Element element, String elementName, String elementValue) {
        element.addContent(createElement(elementName, elementValue, true));
    }

    /**
     * element에 child element를생성한다.
     * 
     * @param element 엘리먼트
     * @param elementName 이름
     * @param elementValue 값
     * @param isCDATA CDATA여부
     * @return
     */
    public static void addChildElement(Element element, String elementName, String elementValue, boolean isCDATA) {
        element.addContent(createElement(elementName, elementValue, isCDATA));
    }

    /**
     * element에 childElement를 child로 생성한다.
     * 
     * @param element
     * @param childElement
     */
    public static void addChildElement(Element element, Element childElement) {
        element.addContent(childElement);
    }

    /**
     * 성공 XML 생성
     * 
     * @param rootElement
     * @return
     */
    public static String createSuccessXml(Element rootElement) {

        return createResponseXml(rootElement, "", "0");
    }

    /**
     * 성공 XML 생성
     * 
     * @param rootElement
     * @param returnDesc
     * @return
     */
    public static String createSuccessXml(Element rootElement, String returnDesc) {

        return XmlUtil.createResponseXml(rootElement, returnDesc, "0");
    }

    /**
     * 성공 XML 생성
     * 
     * @param rootElement
     * @param returnDesc
     * @param returnCode
     * @return
     */
    public static String createResponseXml(Element rootElement, String returnDesc, String returnCode) {
        // 1.Envelop XML을 생성한다.
        Element envelope = XmlUtil.createEnvelope();
        // 2.Body XML을 생성한다.
        Element body = XmlUtil.createBody();
        // 3.WAT_RESPONSE 를 생성한다.
        Element waitResponse = XmlUtil.createWaitResponse();

        XmlUtil.addChildElement(rootElement, "returnDesc", StringUtils.isBlank(returnDesc) ? "" : returnDesc);
        XmlUtil.addChildElement(rootElement, "returnCode", StringUtils.isBlank(returnCode) ? "0" : returnCode);
        XmlUtil.addChildElement(waitResponse, rootElement);
        XmlUtil.addChildElement(body, waitResponse);
        XmlUtil.addChildElement(envelope, body);

        return XmlUtil.convertString(new Document(envelope));
    }

    /**
     * 에러가 발생할경우 XML
     * 
     * @param itemsName item element name
     * @param errorCode 에러코드
     * @param errorMsg 에러 메시지
     * @return
     */
    public static String createErroXml(String itemsName, String errorCode, String errorMsg) {
        // 1.Envelop XML을 생성한다.
        Element envelope = XmlUtil.createEnvelope();
        // 2.Body XML을 생성한다.
        Element body = XmlUtil.createBody();
        // 3.WAT_RESPONSE 를 생성한다.
        Element waitResponse = XmlUtil.createWaitResponse();
        // 4.bbsMenus를 생성한다.
        Element items = XmlUtil.createItems(itemsName);
        // 5.실패인경우 에러코드:999, 에러 사유를 세팅한다.
        XmlUtil.addChildElement(items, "returnDesc", errorMsg);
        XmlUtil.addChildElement(items, "returnCode", errorCode);
        XmlUtil.addChildElement(waitResponse, items);
        XmlUtil.addChildElement(body, waitResponse);
        XmlUtil.addChildElement(envelope, body);
        // 6.최종적으로 XML Document를 XML String을 변환한다.
        return XmlUtil.convertString(new Document(envelope));
    }

}