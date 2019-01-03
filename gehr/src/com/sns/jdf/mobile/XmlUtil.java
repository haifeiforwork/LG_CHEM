package com.sns.jdf.mobile;

import org.apache.commons.lang.StringUtils;
import org.jdom.CDATA;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Namespace;
import org.jdom.output.XMLOutputter;

/** jdom�� �̿��Ͽ� XML ������ ���� Util �̴� */
public class XmlUtil {

    /**
     * XMLDocument�� XML String ���� �����´�.
     * 
     * @param document
     * @return XML String
     */
    public static String convertString(Document document) {
        XMLOutputter outputter = new XMLOutputter();
        return outputter.outputString(document);
    }

    /**
     * XML Root�� �����Ѵ�.
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
     * Body XML�� �����Ѵ�.
     * <soapenv:Body>
     * 
     * @return
     */
    public static Element createBody() {
        Element body = new Element("Body", "soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
        return body;
    }

    /**
     * WAT_RESPONSE XML�� �����Ѵ�.
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
     * Itesms Elements�� �����Ѵ�.
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
     * XML Root�� �����Ѵ�.
     * 
     * @param rootElementName �ֻ��� element �̸�
     * @param nameSpace xsi namespece
     * @param noNameSpace noNamespaceSchemaLocation
     * @return
     */
    public static Element createXmlDocuemnt(String rootElementName) {
        return createXmlDocuemnt(rootElementName, null, null);
    }

    /**
     * XML Root�� �����Ѵ�.
     * 
     * @param rootElementName �ֻ��� element �̸�
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
     * XML Element�� �����Ѵ�.
     * 
     * @param elementName ������Ʈ �̸�
     * @return element
     */
    public static Element createElement(String elementName) {
        return createElement(elementName, null, true);
    }

    /**
     * XML Element�� �����Ѵ�.
     * ex)<appId>APPID001</appId>
     * 
     * @param elementName ������Ʈ �̸�
     * @param elementValue ������Ʈ ��
     * @return element
     */
    public static Element createElement(String elementName, String elementValue) {
        return createElement(elementName, elementValue, true);
    }

    /**
     * XML Element�� �����Ѵ�.
     * ex)<appId>APPID001</appId>
     * 
     * @param elementName �̸�
     * @param elementValue ��
     * @param isCDATA CDATA ����
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
     * element�� child element�������Ѵ�.
     * 
     * @param element ������Ʈ
     * @param elementName �̸�
     * @param elementValue ��
     * @return
     */
    public static void addChildElement(Element element, String elementName, String elementValue) {
        element.addContent(createElement(elementName, elementValue, true));
    }

    /**
     * element�� child element�������Ѵ�.
     * 
     * @param element ������Ʈ
     * @param elementName �̸�
     * @param elementValue ��
     * @param isCDATA CDATA����
     * @return
     */
    public static void addChildElement(Element element, String elementName, String elementValue, boolean isCDATA) {
        element.addContent(createElement(elementName, elementValue, isCDATA));
    }

    /**
     * element�� childElement�� child�� �����Ѵ�.
     * 
     * @param element
     * @param childElement
     */
    public static void addChildElement(Element element, Element childElement) {
        element.addContent(childElement);
    }

    /**
     * ���� XML ����
     * 
     * @param rootElement
     * @return
     */
    public static String createSuccessXml(Element rootElement) {

        return createResponseXml(rootElement, "", "0");
    }

    /**
     * ���� XML ����
     * 
     * @param rootElement
     * @param returnDesc
     * @return
     */
    public static String createSuccessXml(Element rootElement, String returnDesc) {

        return XmlUtil.createResponseXml(rootElement, returnDesc, "0");
    }

    /**
     * ���� XML ����
     * 
     * @param rootElement
     * @param returnDesc
     * @param returnCode
     * @return
     */
    public static String createResponseXml(Element rootElement, String returnDesc, String returnCode) {
        // 1.Envelop XML�� �����Ѵ�.
        Element envelope = XmlUtil.createEnvelope();
        // 2.Body XML�� �����Ѵ�.
        Element body = XmlUtil.createBody();
        // 3.WAT_RESPONSE �� �����Ѵ�.
        Element waitResponse = XmlUtil.createWaitResponse();

        XmlUtil.addChildElement(rootElement, "returnDesc", StringUtils.isBlank(returnDesc) ? "" : returnDesc);
        XmlUtil.addChildElement(rootElement, "returnCode", StringUtils.isBlank(returnCode) ? "0" : returnCode);
        XmlUtil.addChildElement(waitResponse, rootElement);
        XmlUtil.addChildElement(body, waitResponse);
        XmlUtil.addChildElement(envelope, body);

        return XmlUtil.convertString(new Document(envelope));
    }

    /**
     * ������ �߻��Ұ�� XML
     * 
     * @param itemsName item element name
     * @param errorCode �����ڵ�
     * @param errorMsg ���� �޽���
     * @return
     */
    public static String createErroXml(String itemsName, String errorCode, String errorMsg) {
        // 1.Envelop XML�� �����Ѵ�.
        Element envelope = XmlUtil.createEnvelope();
        // 2.Body XML�� �����Ѵ�.
        Element body = XmlUtil.createBody();
        // 3.WAT_RESPONSE �� �����Ѵ�.
        Element waitResponse = XmlUtil.createWaitResponse();
        // 4.bbsMenus�� �����Ѵ�.
        Element items = XmlUtil.createItems(itemsName);
        // 5.�����ΰ�� �����ڵ�:999, ���� ������ �����Ѵ�.
        XmlUtil.addChildElement(items, "returnDesc", errorMsg);
        XmlUtil.addChildElement(items, "returnCode", errorCode);
        XmlUtil.addChildElement(waitResponse, items);
        XmlUtil.addChildElement(body, waitResponse);
        XmlUtil.addChildElement(envelope, body);
        // 6.���������� XML Document�� XML String�� ��ȯ�Ѵ�.
        return XmlUtil.convertString(new Document(envelope));
    }

}