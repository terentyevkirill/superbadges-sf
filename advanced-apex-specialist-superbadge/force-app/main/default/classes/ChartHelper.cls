public without sharing class ChartHelper {

    @AuraEnabled
    public static List<chartData> GetInventory() {
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        List<ChartData> cht = new List<ChartData>();
        AggregateResult[] groupedResults = [
            SELECT
                Family,
                SUM(Quantity_Remaining__c) total
            FROM
                Product2
            WHERE
                Quantity_Remaining__c > 0
            GROUP BY
                Family
        ];
        for (AggregateResult ar_i : groupedResults) {
            cht.add(new ChartData(
                (String) ar_i.get('Family'),
                Integer.valueOf(ar_i.get('total')))
            );
        }
        return cht;
    }

    public class ChartData {
        public String name { get; set; }
        public Decimal val { get; set; }

        public ChartData(String name, Decimal val) {
            this.name = name;
            this.val = val;
        }
    }

}