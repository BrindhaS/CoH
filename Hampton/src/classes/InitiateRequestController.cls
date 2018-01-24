public without sharing class InitiateRequestController
{
    public Flow.Interview.Initiate_Request flow { get; set; }
    public Boolean isPortalUser { get; private set; }
    public String retUrl;
    
    public InitiateRequestController()
    {
        isPortalUser = UserInfo.getUserType().contains('CustomerSuccess');
    }
    
    public String getRetUrl()
    {
        if (flow == null) return '';
        
        String res;
        String h = 'https://' + URL.getSalesforceBaseUrl().getHost().replace('c.', '').replace('visual.force', 'salesforce');
        
        if (isPortalUser)
        {
            h = h.replace('https','http');
            res = h + '/apex/PermitTabPortal';
        }
        else
        {
            String rt = (flow.recordTypeId != '' && flow.recordTypeId != null) ? '&RecordType=' + flow.recordTypeId : '';
            res = h + '/' + flow.tabId + '/e?nooverride=1&Name=System+Number' + rt +
                (!String.isBlank(flow.parcelId) ? 
                    '&CF' + flow.parcelLookup + '=' + EncodingUtil.urlEncode(flow.parcelName, 'UTF-8') + 
                    '&CF' + flow.parcelLookup + '_lkid=' + flow.parcelId : '') + 
                (!String.isBlank(flow.projectId) ? 
                    '&CF' + flow.projectLookup + '=' + EncodingUtil.urlEncode(flow.projectName, 'UTF-8') + 
                    '&CF' + flow.projectLookup + '_lkid=' + flow.projectId: '')  + 
                (!String.isBlank(flow.permitId) ? 
                    '&CF' + flow.permitLookup + '=' + EncodingUtil.urlEncode(flow.permitName, 'UTF-8') +
                    '&CF' + flow.permitLookup + '_lkid=' + flow.permitId : '') + 
                (!String.isBlank(flow.agentId) ? 
                    '&CF' + flow.agentLookup + '=' + EncodingUtil.urlEncode(flow.agentName, 'UTF-8') +
                    '&CF' + flow.agentLookup + '_lkid=' + flow.agentId : '') + 
                (!String.isBlank(flow.contractorId) ? 
                    '&CF' + flow.contractorLookup + '=' + EncodingUtil.urlEncode(flow.contractorName, 'UTF-8') +
                    '&CF' + flow.contractorLookup + '_lkid=' + flow.contractorId : '') + 
                (!String.isBlank(flow.applicantId) ? 
                    '&CF' + flow.applicantLookup + '=' + EncodingUtil.urlEncode(flow.applicantName, 'UTF-8') +
                    '&CF' + flow.applicantLookup + '_lkid=' + flow.applicantId : '');
        }
        
        system.debug('****RES: '+res);
        return res;
    }
    
    public pagereference getReference()
    {
        pagereference pr = new pagereference(getRetUrl());
        system.debug('****PR: '+pr);
        pr.setRedirect(true);
        return pr;
    }
    
    @isTest
    private static void testme()
    {
        InitiateRequestController c = new InitiateRequestController();
        pagereference r = c.getReference();
    }
}