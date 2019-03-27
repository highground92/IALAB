package aima.core.probability.bayes.exact;

import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.DynamicBayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.DynamicBayesNet;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.example.ExampleRV;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.search.csp.Assignment;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class ExampleDBN {

    public static Factor earthquakeDBN(String name) {
        AssignmentProposition[] emptyAssignment = new AssignmentProposition[0];
        switch (name) {
            case "Earthquake":
                FiniteNode earthquake_t = new FullCPTNode(ExampleRV.EARTHQUAKE_RV, new double[]{
                        // true, true
                        //0.4,
                        // true, false
                        //0.6,
                        // false, true
                        0.3,
                        // false, false
                        0.7});
                return earthquake_t.getCPT().getFactorFor(emptyAssignment);
            case "Burglary":
                FiniteNode burglary_t = new FullCPTNode(ExampleRV.BURGLARY_RV,
                        new double[]{
                                // true, true
                                //0.6,
                                // true, false
                                //0.4,
                                // false, true
                                0.2,
                                // false, false
                                0.8});
                return burglary_t.getCPT().getFactorFor(emptyAssignment);
            case "Alarm":
                FiniteNode alarm_t = new FullCPTNode(ExampleRV.ALARM_RV,
                        new double[]{
                                // true, true
                                0.8,
                                // true, false
                                0.2,
                                // false, true
                               // 0.5,
                                // false, false
                              //  0.5,
                               // 0.4,
                                //0.6,
                               // 0.2,
                              //  0.8
                        });
                return alarm_t.getCPT().getFactorFor(emptyAssignment);
            case "JohnCalls":
                FiniteNode john_t = new FullCPTNode(ExampleRV.JOHN_CALLS_RV,
                        new double[]{
                                // true, true
                          //      0.7,
                                // true, false
                            //    0.3,
                                // false, true
                                0.8,
                                // false, false
                                0.2});
                return john_t.getCPT().getFactorFor(emptyAssignment);
            case "MaryCalls":
                FiniteNode mary_t = new FullCPTNode(ExampleRV.MARY_CALLS_RV,
                        new double[]{
                                // true, true
                          //      0.6,
                                // true, false
                          //      0.4,
                                // false, true
                                0.8,
                                // false, false
                                0.2});

                return mary_t.getCPT().getFactorFor(emptyAssignment);
        }
        return null;
    }
}