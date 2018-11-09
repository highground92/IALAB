import org.encog.ml.bayesian.BayesianNetwork;
import org.encog.ml.bayesian.bif.BIFUtil;

public class testBIFUtil {
    public static void main(String [] args){
        BayesianNetwork bn = BIFUtil.readBIF("C:/Users/Fabio/Desktop/cancer.xmlbif");
        System.out.println(bn.toString());
        System.out.println("GETCONTENTS");
        System.out.println(bn.getContents());
        System.out.println("GETPROPERTIES");
        System.out.println(bn.getProperties());
        System.out.println(bn.getEvent("Smoker").getTable());
    }
}
