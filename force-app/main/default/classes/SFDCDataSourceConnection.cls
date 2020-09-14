global class SFDCDataSourceConnection extends DataSource.Connection{
    global DataSource.ConnectionParams connectionInfo;
    public String contractNo;
    
    global SFDCDataSourceConnection(DataSource.ConnectionParams connectionInfo) {
        
        this.connectionInfo = connectionInfo;
    }
    override global List<DataSource.Table> sync() {
        List<DataSource.Table> tables =new List<DataSource.Table>();
        List<DataSource.Column> columns = new List<DataSource.Column>();
        columns.add(DataSource.Column.text('InstallationID', 255));
        columns.add(DataSource.Column.text('ContractSiteDateTo', 255));
        columns.add(DataSource.Column.text('ContractSiteDateFrom', 255));
            columns.add(DataSource.Column.text('ContractSiteBillingClass', 255));
            columns.add(DataSource.Column.text('ContractSiteDeletionIndicator', 255));
            columns.add(DataSource.Column.text('ContractSitePremise', 255));
            columns.add(DataSource.Column.text('SiteID', 255));
            columns.add(DataSource.Column.text('ContractSiteAppRoomNumber', 255));
            columns.add(DataSource.Column.text('ContractSiteHouseNumber', 255));
            columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.url('DisplayUrl'));
        tables.add(DataSource.Table.get('Test Json Data', 'Title',columns));
        return tables;
        
    }
    
    override global DataSource.TableResult query(DataSource.QueryContext context) {//XXX
        String url = 'https://ltngdev-dev-ed.my.salesforce.com';
        DataSource.Filter filter = context.tableSelection.filter;
        if(filter != null){
            if(filter.columnValue != null){
                System.debug(filter.columnValue);
                contractNo = filter.columnValue.toString();
                System.debug(contractNo);
            }
        }
        List<Map<String, Object>> rows =
            DataSource.QueryUtils.process(context, getData());
        return DataSource.TableResult.get(true, null, context.tableSelection.tableSelected, rows);
        
    }
    override global List<DataSource.TableResult> search(DataSource.SearchContext context) {//XXX
        List<DataSource.TableResult> results =new List<DataSource.TableResult>();
        for (Integer i =0;i< context.tableSelections.size();i++) {
            String entity = context.tableSelections[i].tableSelected;
            String likeKey= context.searchPhrase;
            String url ='callout:Salesforce/services/data/v40.0/query?q=Select+Id+,Name,Author_Name__c,Category__c,Publisher_Id__c+from+Books__c+Where+Publisher_Id__c=\''+likeKey+'\'';
            results.add(DataSource.TableResult.get(true, null, entity, getData(url)));
        }
        return results;
    }
    
    global override List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context) {//XXXX
        List<DataSource.UpsertResult> results = new List<DataSource.UpsertResult>();
        List<Map<String, Object>> rows = context.rows;
        for (Map<String, Object> row : rows){
            if (row.get('ExternalId') != null){
                String tempExtids = (String)row.get('ExternalId') ;
                String jsonTemp = '{"name":"' + (String)row.get('Name') + '","id":"' +(String)row.get('ExternalId') + '"}' ;
                String responsePatch = makePatchCallout(tempExtids ,jsonTemp);
                Map<String, Object> responseBodyMapTemp12 = (Map<String, Object>)JSON.deserializeUntyped(responsePatch);
                results.add(DataSource.UpsertResult.success(String.valueOf(responseBodyMapTemp12.get('id'))));
                return results ;
            }else{
                String jsontemp = '{"Name":"' + (String)row.get('Name') + '","Category__c":"' +(String)row.get('Category__c') + '"}' ;
                String  responsePost = makePostCallout(jsontemp);
                Map<String, Object> responseBodyMapTemp34 = (Map<String, Object>)JSON.deserializeUntyped(responsePost);
                results.add(DataSource.UpsertResult.success(String.valueOf(responseBodyMapTemp34.get('id'))));
                return results ;
            }
        }
        return results;
    }
    
    global override List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context) {//XXX
        List<DataSource.DeleteResult> results = new List<DataSource.DeleteResult>();
        for (String externalId : context.externalIds){
            HttpResponse response = makeDeleteCallout(externalId);
            results.add(DataSource.DeleteResult.success(externalId));
        }
        return results;
    }
    
    global List<Map<String, Object>> getData(String url) {
        String response = getResponse(url);
        List<Map<String, Object>> rows =new List<Map<String, Object>>();
        Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        List<Object> fileItems=(List<Object>)responseBodyMap.get('records');
        if (fileItems != null) {
            for (Integer i=0; i < fileItems.size(); i++) {
                System.debug('iii'+fileItems[i]);
                Map<String, Object> item =(Map<String, Object>)fileItems[i];
                rows.add(foundRow(item));  
            }
        } else {
            //  rows.add(foundRow(responseBodyMap));
        }
        return rows;
    }
    
    private Map<String,Object> foundRow(Map<String,Object> foundRow) {
        Map<String,Object> row = new Map<String,Object>();
        row.put('ExternalId', string.valueOf(foundRow.get('Id')));
        row.put('DisplayUrl', string.valueOf(foundRow.get('DisplayUrl')));
        row.put('Name', string.valueOf(foundRow.get('Name')));       
        return row;
    }
    
    
    
    private List<Map<String, Object>> getData() {
        String response = getResponse();
        List<Map<String, Object>> rows =new List<Map<String, Object>>();
        System.debug(response);
        Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        System.debug('responseBodyMap ' + responseBodyMap);
        List<Object> fileItems=(List<Object>)responseBodyMap.get('Records');
        System.debug(fileItems);
        if (fileItems != null) {
            for (Integer i=0; i < fileItems.size(); i++) {
                System.debug(fileItems[i]);
                Map<String, Object> item =(Map<String, Object>)fileItems[i];
                rows.add(createRow(item));  
            }
        } else {
            rows.add(createRow(responseBodyMap));
        }
        return rows;
    }
    
    private  Map<String, Object> createRow(Map<String, Object> item){
        Map<String, Object> row = new Map<String, Object>();
        try{
        for ( String key : item.keySet() ) {
            System.debug(Key);
            if (key == 'ContractNumber') {
                System.debug(item.get(key));
                row.put('ExternalId', item.get(key));
                row.put('DisplayUrl', item.get(key));
                row.put('InstallationID', item.get('InstallationID'));
                row.put('ContractSiteDateTo', item.get('ContractSiteDateTo'));
                row.put('ContractSiteDateFrom', item.get('ContractSiteDateFrom'));
                row.put('ContractSiteBillingClass', item.get('ContractSiteBillingClass'));
                row.put('ContractSiteDeletionIndicator', item.get('ContractSiteDeletionIndicator'));
                row.put('ContractSitePremise', item.get('ContractSitePremise'));
                row.put('SiteID', item.get('SiteID'));
                row.put('ContractSiteAppRoomNumber', item.get('ContractSiteAppRoomNumber'));
                row.put('ContractSiteHouseNumber', item.get('ContractSiteHouseNumber'));
                
            } else {
                row.put(key, item.get(key));
            }
        }
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
        return row;     
    }
    
    private  HttpResponse makeDeleteCallout(String recid) {//XXX
        String url ='callout:Salesforce/services/data/v41.0/sobjects/Books__c/'+recid;
        
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(url);
        request.setMethod('DELETE');
        request.setHeader('Authorization', this.connectionInfo.oauthToken);
        HttpResponse response = h.send(request);
        return response;
        
    }
    
    private  String makePatchCallout(String extenalId , String jsonBody) {//XXX
        String url ='callout:Salesforce/services/data/v41.0/sobjects/Books__c/'+extenalId;
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(url);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonBody);
        request.setHeader('Authorization', this.connectionInfo.oauthToken);
        request.setMethod('PATCH');
        HttpResponse response = h.send(request);
        return response.getBody();
        
    }
    private String makePostCallout( String jsonBody) {//XXX
        
        System.debug(' POST CALL --------');
        
        String url ='callout:Salesforce/services/data/v41.0/sobjects/Books__c';
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonBody);
        request.setHeader('Authorization', this.connectionInfo.oauthToken);
        HttpResponse response = h.send(request);
        System.debug(' IN POST CALL RESPONCE ---'+response.getBody());
        return response.getBody();
    }
    private String getResponse() {
        
        String endPoint = 'https://elastic.snaplogic.com:443/api/1/rest/slsched/feed/EnmaxQA/projects/SFDC%20POC/Task_SAP_Snap_DB';
        String auth = 'F4z7U4ZOz7JYYpUm3N4mZzsIsSqh7p9K';
        if(contractNo == null || contractNo == ''){
            contractNo = '4006064330';
        }

        String EndpointWithData = endPoint + '?Contract_Number=' + ContractNo;
        
        
        HttpRequest reqRESTReq= new HttpRequest();
        Http http = new Http();
        
        reqRESTReq.setEndpoint(EndpointWithData);
        reqRESTReq.setMethod('GET');
        reqRESTReq.setTimeout(120000);
        reqRESTReq.setHeader('Authorization' , 'Bearer '+auth );
        HttpResponse reqRESTRes = http.send(reqRESTReq);
        System.debug(reqRESTRes);
        
        if(reqRESTRes.getStatusCode() == 200){
            System.debug(reqRESTRes.getBody());
            return '{ "Records" : ' + reqRESTRes.getBody() + '}';
        }else{
            return 'null';
        }
        // String url ='https://www.healthcare.gov/api/blog.json';
        // Http h = new Http();
        // HttpRequest request = new HttpRequest();
        // request.setEndPoint(url);
        // request.setMethod('GET');
        // request.setHeader('Authorization', '');
        // HttpResponse response = h.send(request);
        // System.debug(response.getBody());
        // return response.getBody();
    } 
    private String getResponse(String url) {
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(url);
        request.setMethod('GET');
        request.setHeader('Authorization', this.connectionInfo.oauthToken);
        HttpResponse response = h.send(request);
        return response.getBody();
    } 
    
}