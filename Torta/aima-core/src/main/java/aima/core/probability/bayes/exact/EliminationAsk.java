package aima.core.probability.bayes.exact;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

import aima.core.probability.CategoricalDistribution;
import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.*;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.DynamicBayesNet;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.domain.ArbitraryTokenDomain;
import aima.core.probability.example.ExampleRV;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;
import aima.core.probability.util.RandVar;
import aima.core.search.csp.Assignment;
import org.encog.ml.bayesian.BayesianChoice;
import org.encog.ml.bayesian.BayesianEvent;
import org.encog.ml.bayesian.bif.BIFUtil;
import org.encog.ml.bayesian.table.TableLine;

import static aima.core.probability.bayes.exact.BayesianMain.moveToLastPosition;

/**
 * Artificial Intelligence A Modern Approach (3rd Edition): Figure 14.11, page
 * 528.<br>
 * <br>
 *
 * <pre>
 * function ELIMINATION-ASK(X, e, bn) returns a distribution over X
 *   inputs: X, the query variable
 *           e, observed values for variables E
 *           bn, a Bayesian network specifying joint distribution P(X<sub>1</sub>, ..., X<sub>n</sub>)
 *
 *   factors <- []
 *   for each var in ORDER(bn.VARS) do
 *       factors <- [MAKE-FACTOR(var, e) | factors]
 *       if var is hidden variable the factors <- SUM-OUT(var, factors)
 *   return NORMALIZE(POINTWISE-PRODUCT(factors))
 * </pre>
 *
 * Figure 14.11 The variable elimination algorithm for inference in Bayesian
 * networks. <br>
 * <br>
 * <b>Note:</b> The implementation has been extended to handle queries with
 * multiple variables. <br>
 *
 * @author Ciaran O'Reilly
 */
public class EliminationAsk implements BayesInference {
	//
	private static final ProbabilityTable _identity = new ProbabilityTable(
			new double[] { 1.0 });

	public static List<Node> irrelevantList = new ArrayList<>();

	public EliminationAsk() {

	}

	public static List<RandomVariable> applyVariableElimination(RandomVariable[] X, AssignmentProposition[] e, BayesianNetwork bn, List<RandomVariable> vars, int heuristic){
		Graph graph = new Graph(bn,vars);
		Set<Node> tempSetRv = new HashSet<>();

		for (int i=0;i<X.length;i++){
			tempSetRv.add(bn.getNode(X[i]));
		}
		Set<AssignmentProposition> tempSetE = new HashSet<>();
		for (int j=0;j<e.length;j++){
			tempSetE.add(e[j]);
		}

		//List<Node> tempList = graph.getNotMSeparatedGraph(tempSetRv,tempSetE);

		List<Node> tempList = graph.getGraph();
		//System.out.println("stampa temp_list");
		//for(Node tm : tempList){
		//	System.out.println(tm.getRandomVariable().getName());
		//}

		GreedyOrdering go = new GreedyOrdering();
		return go.greedyOrdering(heuristic,tempList,bn);

	}

	//
	// START-BayesInference
	public CategoricalDistribution ask(final RandomVariable[] X,
									   final AssignmentProposition[] observedEvidence,
									   final BayesianNetwork bn) {
		try {
			return this.eliminationAsk(X, observedEvidence, bn);
		} catch (IOException e){
			e.printStackTrace();
		}
		return null;
	}

	/*
	effettua il Rollup Filtering su dynamic bayesian network
	x0 = belief state, x1 = transition
	Abbiamo n evidence dove n è il numero della random variable chiesta dalla query (utilizzeremo quindi n+1 slice, contando quella iniziale)
	Si parte dal prior network e si applica elimination variable alle slice 0 e 1, ottenendo il primo fattore f1
	Utilizziamo f1 insieme alle cpt relative alle slice 1 e 2 per ottenere il fattore f2 e così via fino ad fn

	*/
	public static Factor applyDbnEliminationVariable(BayesianNetwork bn, BayesianNetwork bnt, int n, HashMap evidenceDBN,
                                                     String path_txt) throws IOException {

        RandomVariable[] query = SupportStructureBN.query;
        AssignmentProposition[] assig = SupportStructureBN.assig;

        AssignmentProposition[] assigT = new AssignmentProposition[assig.length];
        System.arraycopy(assig,0,assigT,0,assig.length);


        Map<RandomVariable,Factor> mapFactorBN = new HashMap<>();
        Map<RandomVariable,Factor> mapFactorBNT = new HashMap<>();
        Map<RandomVariable,Factor> mapFactorEvidence = new HashMap<>();
        AssignmentProposition[] assigVuota = new AssignmentProposition[0];
		//Map<RandomVariable,Factor> factorsMapSlice0 = new HashMap<>();


       /* for(RandomVariable rv : bn.getVariablesInTopologicalOrder()){
            for(AssignmentProposition as : assig)
                if(!rv.getName().equals(as.getTermVariable().getName()))
                    mapFactorBN.put(rv,EliminationAsk.makeFactor(rv,assig,bn));
                else
                    mapFactorEvidence.put(rv,EliminationAsk.makeFactor(rv,assig,bn));
        }*/
        // Creo la map delle rv della rete bayesiana che rappresenta le transizioni


        // Creo la map delle rv della rete bayesiana base
        for(RandomVariable rv : bnt.getVariablesInTopologicalOrder()){
            if(!rv.getName().endsWith("T")){
                for(AssignmentProposition as : assig){
                    if(!rv.getName().equals((as.getTermVariable().getName())))
                        mapFactorBN.put(rv,EliminationAsk.makeFactor(rv,assig,bnt));
                    else
                        mapFactorEvidence.put(rv,EliminationAsk.makeFactor(rv,assig,bnt));
                }
            }
        }

        int y = 0;
        for(RandomVariable rv : mapFactorEvidence.keySet()) {
            RandomVariable rvT = new RandVar(rv.getName() + "T", rv.getDomain());
            assigT[y] = new AssignmentProposition(rvT, assig[y].getValue());
            y++;
        }


        System.out.println("VALORE ASSIGT: "+ assigT[0].getValue());
		System.out.println("VALORE ASSIG: "+ assig[0].getValue());

        for(RandomVariable rv : bnt.getVariablesInTopologicalOrder()){
            if(rv.getName().endsWith("T")){
                for(AssignmentProposition as : assig){
                    if(!rv.getName().equals((as.getTermVariable().getName()+"T")))
                        mapFactorBNT.put(rv,EliminationAsk.makeFactor(rv,assigT,bnt));
                }
            }
        }


        System.out.println("Valori BN Base");
        for(RandomVariable rv : mapFactorBN.keySet()){
            System.out.println("Variabile: "+ rv + " valore: "+ mapFactorBN.get(rv));
        }

        System.out.println("Valori BN Transizione");
        for(RandomVariable rv : mapFactorBNT.keySet()){
            System.out.println("Variabile: "+ rv + " valore: "+ mapFactorBNT.get(rv));
        }


        System.out.println("Valori Evidence");
        for(RandomVariable rv : mapFactorEvidence.keySet()){
            System.out.println("Variabile: "+ rv + " valore: "+ mapFactorEvidence.get(rv));
        }

        /*
        Scanner input = new Scanner(System.in);
        System.out.println("1-Max Cardinality");
        System.out.println("2-Min Neighbours");
        System.out.println("3-Min Weight");
        System.out.println("4-Min Fill");
        System.out.println("5-Min Weight Fill");
        int heuristic = input.nextInt();
        input.close();
        */
        /*
		for(RandomVariable rv : query){
			factorsMapSlice0.put(rv,EliminationAsk.makeFactor(rv,assig,bn));
		}
        */
        //System.out.println("slice prima del while chiavi " + factorsMapSlice0.keySet() + " valori " + factorsMapSlice0.values());

        int i = 0;
		while(i<n){ //il numero di slice assumiamo che sia implicito in base a quanti valori hanno le evidence
            System.out.println("-----------------------------------");

            //------------------------------------------------------------------------------------
            //Aggiorno assig con il valore di verità letto da file e salvato in evidenceDBN
            for(AssignmentProposition ap : assig){
                for(Object name : evidenceDBN.keySet()){
                    if(ap.getTermVariable().getName().equals(name)){
                        //System.out.println("Valore vecchio: "+ap.getValue());
                        List<String> temp = (List<String>) evidenceDBN.get(name);
                        String value = temp.remove(0);
                        //System.out.println("Valore nuovo: "+value);
                        ap.setValue(value);
                    }
                }
            }
            for(AssignmentProposition as : assig)
                System.out.println("Nuovo valore di Assig: "+ as.getValue());

            // Aggiorno la map evidence usando l'assig modificato
            for(RandomVariable rv : bn.getVariablesInTopologicalOrder()){
                for(AssignmentProposition as : assig)
                    if(rv.getName().equals(as.getTermVariable().getName()))
                        mapFactorEvidence.put(rv,EliminationAsk.makeFactor(rv,assig,bn));
            }
            System.out.println("Valori Evidence modificati");
            for(RandomVariable rv : mapFactorEvidence.keySet()){
                System.out.println("Variabile: "+ rv + " valore: "+ mapFactorEvidence.get(rv));
            }
            //--------------------------------------------------------------------------------------

            List<Factor> tempList = new ArrayList<>();
            for(RandomVariable rv : mapFactorBNT.keySet()){
                tempList.add(mapFactorBNT.get(rv));
            }
            for(RandomVariable rv : mapFactorBN.keySet()){
                tempList.add(mapFactorBN.get(rv));
            }


            for(RandomVariable rv : mapFactorBN.keySet()){
                tempList=sumOut(rv,tempList);
            }

            Factor tm = pointwiseProduct(tempList);
            /*
            for(Factor f : tempList){
                System.out.println("TempList: "+f);
                System.out.println("RV"+f.getArgumentVariables());
            }*/

            for(RandomVariable rv : mapFactorEvidence.keySet()){
                tm = mapFactorEvidence.get(rv).pointwiseProduct(tm);
            }
            System.out.println("VALORE TM: "+tm);

            /*
            System.out.println("Fattori della BN Moltiplicati");
            for(RandomVariable rv : mapFactorBN.keySet()){
                System.out.println("Variabile: "+ rv + " valore: "+ mapFactorBN.get(rv));
            }*/

            i++;
		}


        System.out.println("\nIL NOSTRO RISULTATO");

		return null;
	}

	// function ELIMINATION-ASK(X, e, bn) returns a distribution over X
	/**
	 * The ELIMINATION-ASK algorithm in Figure 14.11.
	 *
	 * @param X
	 *            the query variables.
	 * @param e
	 *            observed values for variables E.
	 * @param bn
	 *            a Bayes net with variables {X} &cup; E &cup; Y /* Y = hidden
	 *            variables //
	 * @return a distribution over the query variables.
	 */
	public CategoricalDistribution eliminationAsk(final RandomVariable[] X,
												  final AssignmentProposition[] e, final BayesianNetwork bn) throws IOException {

		//BayesianNetwork bn = BayesianMain.buildNetwork();

		/*FileReader file = new FileReader("./retiBayesiane/earthquake.txt");
		BufferedReader rete = new BufferedReader(file);
		String delims = "[ ]+";
		String[] split;
		String line = rete.readLine();
		int nVar = 0;
		String qVar = "";
		HashMap<String, String> var = new HashMap<>();
		while (line != null) {
			nVar++;
			split = line.split(delims);
			if(nVar == 1)
				qVar = split[1];
			else {
				if (!qVar.equalsIgnoreCase(split[0])) {
					if (!split[1].equalsIgnoreCase("________")) {
						var.put(split[0], split[1]);
					}
				}
			}
			line = rete.readLine();
		}

		rete.close();
		file.close();

		RandomVariable[] query = new RandomVariable[1];
		AssignmentProposition[] assig= assig = new AssignmentProposition[var.size()];

		int i=0;
		for(RandomVariable v : bn.getVariablesInTopologicalOrder()){
			if(v.getName().equalsIgnoreCase(qVar))
				query[0] = v;
			else {
				if (var.get(v.getName()) != null) {
					assig[i] = new AssignmentProposition(v, var.get(v.getName()));
					i++;
				}
			}
		}

		System.out.println(query[0]);
		for(int j=0; j<assig.length; j++)
			System.out.println(assig[j].toString());
		System.out.println();

		/*
		Scanner input = new Scanner(System.in);
		System.out.println("1-Elimination Variable");
		System.out.println("2-MPE");
		System.out.println("3-MAP");
		*/

		/*int number = 1;

		if (number == 1){
			//varElim contiene la lista ordinata di random variables
			List<RandomVariable> varElim = EliminationAsk.applyVariableElimination(query,assig,bn);
			//rimuove le irrelevant variables e ritorna le hidden variables
			System.out.println("gesu");
			Set<RandomVariable> hidden = EliminationAsk.calculateVariables(query, assig, bn, varElim);
			System.out.println("prima");
			System.out.println();
			List<RandomVariable> remainingVars = new ArrayList<RandomVariable>(varElim);
			Graph graph = new Graph(bn,remainingVars);
			//trasformiamo da array a Set
			Set<Node> tempSetRv = new HashSet<>();
			for (int k=0;k<query.length;k++){
				tempSetRv.add(bn.getNode(query[k]));
			}
			Set<AssignmentProposition> tempSetE = new HashSet<>();
			for (int j=0;j<assig.length;j++){
				tempSetE.add(assig[j]);
			}
			List<Node> tempList = graph.getNotMSeparatedGraph(tempSetRv,tempSetE);
			//tempListRv è la lista delle rv avendo eliminato le irrelevant e avendo applicato l'm-separated
			List<RandomVariable> tempListRv = new ArrayList<>();
			for(Node z : tempList){
				tempListRv.add(z.getRandomVariable());
			}

			List<Factor> factors = new ArrayList<Factor>();
			for(RandomVariable rv : tempListRv){
				//System.out.println("var: "+var);
				// factors <- [MAKE-FACTOR(var, e) | factors]
				//System.out.println("makefactor: "+makeFactor(var, e, bn));
				factors.add(0, EliminationAsk.makeFactor(rv, assig, bn));
			}

			factors = EliminationAsk.sumOutVar(tempListRv,factors,hidden,bn);

			System.out.println("----------------------------");

			Factor product = EliminationAsk.pointwiseProduct(factors).maxOut(query);

			EliminationAsk.printResult(product);

			System.out.println((ProbabilityTable) product);
		} else if (number == 2){
			//Graph graph = new Graph(bn,remainingVars);
			//return EliminationAsk.eliminationAskMPE(query, assig, bn, graph);
		} else if (number == 3) {
			//return eliminationAskSMAP(X, e, bn, hidden, VARS);
		} else {
			System.out.println("Numero inesistente!");
		}*/
		return null;
		//DELETE
	}

	public static CategoricalDistribution eliminationAskMPE(final RandomVariable[] X,
														 final AssignmentProposition[] e, final BayesianNetwork bn,
														 Set<RandomVariable> hidden, Graph graph, int heuristic){
		// factors <- []
		List<Factor> factors = new ArrayList<Factor>();

		GreedyOrdering go = new GreedyOrdering();
		List<RandomVariable> order = go.greedyOrdering(heuristic,graph.getGraph(),bn);
		//System.out.println("ORDER\n"+order);
		for(RandomVariable var : order){
			//System.out.println("var: "+var);
			// factors <- [MAKE-FACTOR(var, e) | factors]
			//System.out.println("makefactor: "+makeFactor(var, e, bn));
			factors.add(0, makeFactor(var, e, bn));
		}

		factors = sumOutVarMPE(order,factors,hidden,bn);

		System.out.println("----------------------------");

		Factor product = pointwiseProduct(factors).maxOut(X);

		printResult(product);

		return (ProbabilityTable) product;

		// return NORMALIZE(POINTWISE-PRODUCT(factors))
		//return ((ProbabilityTable) product.pointwiseProductPOS(_identity, X)).normalize();
	}

	public CategoricalDistribution eliminationAskMAP(final RandomVariable[] X,
													 final AssignmentProposition[] e, final BayesianNetwork bn,
													 Set<RandomVariable> hidden, Graph graph, int heuristic){
		// factors <- []
		List<Factor> factors = new ArrayList<Factor>();
		List lol;

		GreedyOrdering go = new GreedyOrdering();
		List<RandomVariable> order = go.greedyOrdering(heuristic,graph.getGraph(),bn);
		List<RandomVariable> orderedHidden = new ArrayList<>();
		List<RandomVariable> orderedQuery = new ArrayList<>();
		for(RandomVariable rv : order){
			if (hidden.contains(rv))
				orderedHidden.add(rv);
			else
				orderedQuery.add(rv);
		}
		List<RandomVariable> orderedFinal = new ArrayList<>();
		orderedFinal.addAll(orderedHidden);
		orderedFinal.addAll(orderedQuery);

		//System.out.println("ORDER\n"+order);
		for(RandomVariable var : orderedFinal){
			//System.out.println("var: "+var);
			// factors <- [MAKE-FACTOR(var, e) | factors]
			//System.out.println("makefactor: "+makeFactor(var, e, bn));
			factors.add(0, makeFactor(var, e, bn));
		}


		factors = sumOutVarMPE(orderedFinal,factors,hidden,bn);

		System.out.println("----------------------------");

		Factor product = pointwiseProduct(factors).maxOut(X);

		printResult(product);

		return (ProbabilityTable) product;
	}


	/* VECCHIO MAP
			List<Factor> factors = new ArrayList<Factor>();
		for(RandomVariable x : X)
			bnVARS.remove(x);
		for(RandomVariable v : bnVARS)
			System.out.println(v.getName());
		List<RandomVariable> orderQ = new ArrayList<>(bnVARS);
		// calcolo P(Q|e) con order senza le variabili in Q
		System.out.println("ORDER\n"+orderQ);
		for(RandomVariable var : orderQ){
			System.out.println("var: "+var);
			// factors <- [MAKE-FACTOR(var, e) | factors]
			System.out.println("makefactor: "+makeFactor(var, e, bn));
			factors.add(0, makeFactor(var, e, bn));
		}
		factors = sumOutVar(orderQ,factors,hidden,bn);

		// variabili rimanenti
		List<RandomVariable> varQ = new ArrayList<>();
		for(RandomVariable x : X)
			varQ.add(x);
		for(RandomVariable x : X)
			System.out.println(x.getName());
		for(RandomVariable var : varQ){
			System.out.println("var: "+var);
			// factors <- [MAKE-FACTOR(var, e) | factors]
			System.out.println("makefactor: "+makeFactor(var, e, bn));
			factors.add(0, makeFactor(var, e, bn));
		}
		System.out.println("MAP");

		factors = map(varQ,factors,bn);
		System.out.println(factors);
		Factor product = pointwiseProduct(factors);

		return ((ProbabilityTable) product.pointwiseProductPOS(_identity, X));
	 */





	// END-BayesInference
	//

	//
	// PROTECTED METHODS
	//
	/**
	 * <b>Note:</b>Override this method for a more efficient implementation as
	 * outlined in AIMA3e pgs. 527-28. Calculate the hidden variables from the
	 * Bayesian Network. The default implementation does not perform any of
	 * these.<br>
	 * <br>
	 * Two calcuations to be performed here in order to optimize iteration over
	 * the Bayesian Network:<br>
	 * 1. Calculate the hidden variables to be enumerated over. An optimization
	 * (AIMA3e pg. 528) is to remove 'every variable that is not an ancestor of
	 * a query variable or evidence variable as it is irrelevant to the query'
	 * (i.e. sums to 1). 2. The subset of variables from the Bayesian Network to
	 * be retained after irrelevant hidden variables have been removed.
	 *
	 * @param X
	 *            the query variables.
	 * @param e
	 *            observed values for variables E.
	 * @param bn
	 *            a Bayes net with variables {X} &cup; E &cup; Y /* Y = hidden
	 *            variables //
	 * @return hidden
	 *            to be populated with the relevant hidden variables Y.
	 * @param bnVARS
	 *            to be populated with the subset of the random variables
	 *            comprising the Bayesian Network with any irrelevant hidden
	 *            variables removed.
	 */
	public static Set<RandomVariable> calculateVariables(final RandomVariable[] X,
														 final AssignmentProposition[] e, final BayesianNetwork bn, Collection<RandomVariable> bnVARS) {
		Set<RandomVariable> hidden = new HashSet<>();
		hidden.addAll(bnVARS);

		for (RandomVariable x : X) {
			hidden.remove(x);
		}
		for (AssignmentProposition ap : e) {
			hidden.removeAll(ap.getScope());
		}

		System.out.println("HIDDEN");
		for(RandomVariable h : hidden){
			System.out.println(h.getName());
		}
		System.out.println("\nEVIDENCE");
		for(AssignmentProposition ass: e){
			System.out.println(ass.getTermVariable().getName());
		}

		Set<Node> parents = new HashSet<Node>();
		Set<Node> p = null;
		for(RandomVariable var : bnVARS){
			p = bn.getNode(var).getParents();
			for(Node n : p)
				parents.add(n);
		}

		/*System.out.println("PARENTS");
		for(Node node : parents){
			System.out.print(node.getRandomVariable().getName()+" ");
		}
		System.out.println();*/

		System.out.println("ANCESTORS");
		for(Node node : parents){
			System.out.print(node.getRandomVariable().getName()+" ");
		}
		System.out.println();

		for(RandomVariable h : hidden){
			if(!parents.contains(bn.getNode(h))) {
				System.out.println(h.getName()+" is irrelevant variable");
				bnVARS.remove(h);
				irrelevantList.add(bn.getNode(h));
			}
		}
		return hidden;
	}

	//come calculateVariables ma non elimina le irrelevant variables
	public static Set<RandomVariable> calculateAllVariables(final RandomVariable[] X,
															final AssignmentProposition[] e, final BayesianNetwork bn, Collection<RandomVariable> bnVARS){
		Set<RandomVariable> hidden = new HashSet<>();
		hidden.addAll(bnVARS);

		for (RandomVariable x : X) {
			hidden.remove(x);
		}
		for (AssignmentProposition ap : e) {
			hidden.removeAll(ap.getScope());
		}

		System.out.println("HIDDEN");
		for(RandomVariable h : hidden){
			System.out.print(h.getName()+" ");
		}
		System.out.println("\nEVIDENCE");
		for(AssignmentProposition ass: e){
			System.out.println(ass.getTermVariable().getName());
		}

		Set<Node> parents = new HashSet<Node>();
		Set<Node> p = null;
		for(RandomVariable var : bnVARS){
			p = bn.getNode(var).getParents();
			for(Node n : p)
				parents.add(n);
		}

		/*System.out.println("PARENTS");
		for(Node node : parents){
			System.out.print(node.getRandomVariable().getName()+" ");
		}
		System.out.println();*/

		System.out.println("ANCESTORS");
		for(Node node : parents){
			System.out.print(node.getRandomVariable().getName()+" ");
		}
		System.out.println();
		return hidden;
	}

	/**
	 * <b>Note:</b>Override this method for a more efficient implementation as
	 * outlined in AIMA3e pgs. 527-28. The default implementation does not
	 * perform any of these.<br>
	 *
	 * @param bn
	 *            the Bayesian Network over which the query is being made. Note,
	 *            is necessary to provide this in order to be able to determine
	 *            the dependencies between variables.
	 *            //* @param vars
	 *            a subset of the RandomVariables making up the Bayesian
	 *            Network, with any irrelevant hidden variables alreay removed.
	 * @return a possibly optimal ordering for the random variables to be
	 *         iterated over by the algorithm. For example, one fairly effective
	 *         ordering is a greedy one: eliminate whichever variable minimizes
	 *         the size of the next factor to be constructed.
	 */
	/*
	protected List<RandomVariable> order(BayesianNetwork bn,
										 Collection<RandomVariable> vars,
										 Set<AssignmentProposition> e, Set<Node> X) {
		// Note: Trivial Approach:
		// For simplicity just return in the reverse order received,
		// i.e. received will be the default topological order for
		// the Bayesian Network and we want to ensure the network
		// is iterated from bottom up to ensure when hidden variables
		// are come across all the factors dependent on them have
		// been seen so far.

		List<RandomVariable> var = new ArrayList<RandomVariable>(vars);
		//Collections.reverse(var);

		Graph graph = new Graph(bn,var);
		//System.out.println("ACYCLIC GRAPH\n"+graph.toString());

		graph.getNotMSeparatedGraph(X,e);

		System.out.println("M-SEPARATED GRAPH\n"+graph.toString());

		//List<RandomVariable> order = graph.maxCardinality();
		List<RandomVariable> order = graph.greedyOrdering("MinNeighbors");
		//List<RandomVariable> order = graph.greedyOrdering("MinWeight");
		//List<RandomVariable> order = graph.greedyOrdering("MinFill");
		//List<RandomVariable> order = graph.greedyOrdering("minWeightFill");

		return order;
	}
	*/

	//
	// PRIVATE METHODS
	//
	public static Factor makeFactor(RandomVariable var, AssignmentProposition[] e,
							  BayesianNetwork bn) {

		Node n = bn.getNode(var);
		if (!(n instanceof FiniteNode)) {
			throw new IllegalArgumentException(
					"Elimination-Ask only works with finite Nodes.");
		}
		FiniteNode fn = (FiniteNode) n;
		List<AssignmentProposition> evidence = new ArrayList<AssignmentProposition>();
		for (AssignmentProposition ap : e) {
			if (fn.getCPT().contains(ap.getTermVariable())) {
				evidence.add(ap);
			}
		}
		/*
		Factor ret = fn.getCPT().getFactorFor(
				evidence.toArray(new AssignmentProposition[evidence.size()]));
		for(RandomVariable rv : ret.getRandomVarInfo().keySet()){
			if (irrelevantList.contains(bn.getNode(rv))){
				ret.getRandomVarInfo().keySet().clear();
			}
		}
		System.out.println("RV " + ret.getRandomVarInfo().keySet());
		*/
		return fn.getCPT().getFactorFor(
				evidence.toArray(new AssignmentProposition[evidence.size()]));
	}

	public static List<Factor> sumOutVar(List<RandomVariable> order, List<Factor> factors,
								   Set<RandomVariable> hidden){
		for(RandomVariable var : order){
			if(hidden.contains(var)){
				//System.out.println("sumOut var: "+var.getName());
				factors = sumOut(var, factors);
				//for(int i=0; i<factors.size(); i++)
					//System.out.println("dopo sumout: "+factors.get(i));
			}
		}
		return factors;
	}

	public static List<Factor> sumOutVarMPE(List<RandomVariable> order, List<Factor> factors,
										 Set<RandomVariable> hidden, BayesianNetwork bn){

		for(RandomVariable var : order){
			if(hidden.contains(var)){
				//System.out.println("sumOut var: "+var.getName());
				factors = sumOutMPE(var, factors,bn);
				//for(int i=0; i<factors.size(); i++)
				//System.out.println("dopo sumout: "+factors.get(i));
			}
		}
		return factors;
	}

	private static List<Factor> sumOut(RandomVariable var, List<Factor> factors) {
		List<Factor> summedOutFactors = new ArrayList<Factor>();
		List<Factor> toMultiply = new ArrayList<Factor>();
		for (Factor f : factors) {
			//System.out.println("factor: "+f);
			if (f.contains(var)) {
				//System.out.println("f cont var "+f.getArgumentVariables().toString());
				toMultiply.add(f);
			} else {
				// This factor does not contain the variable
				// so no need to sum out - see AIMA3e pg. 527.
				summedOutFactors.add(f);
			}
		}
		//sumOut
		summedOutFactors.add(pointwiseProduct(toMultiply).sumOut(var));
		return summedOutFactors;
	}

	private static List<Factor> sumOutMPE(RandomVariable var, List<Factor> factors,
									   BayesianNetwork bn) {
		List<Factor> maxedOutFactors = new ArrayList<Factor>();
		List<Factor> toMultiply = new ArrayList<Factor>();
		for (Factor f : factors) {
			//System.out.println("factor: "+f);
			if (f.contains(var)) {
				//System.out.println("f cont var "+f.getArgumentVariables().toString());
				toMultiply.add(f);
			} else {
				// This factor does not contain the variable
				// so no need to sum out - see AIMA3e pg. 527.
				maxedOutFactors.add(f);
			}
		}
		//inference MPE
		maxedOutFactors.add(pointwiseProduct(toMultiply).maxOut(var));

		return maxedOutFactors;
	}

	public static Factor pointwiseProduct(List<Factor> factors) {

		Factor product = factors.get(0);
		//System.out.println("PRODUCT one "+product.toString());
		for (int i = 1; i < factors.size(); i++) {
			//System.out.println("PRODUCT "+factors.get(i).toString());
			product = product.pointwiseProduct(factors.get(i));
			//System.out.println("PRODUCT "+product.toString());
		}

		return product;
	}

	//public static ArrayList<RandomVariable> resultVariables = new ArrayList<>();
	//new
	public static void printResult(Factor resInference){
		ArrayList<RandomVariable> resultVariables = new ArrayList<>();

		double firstVar = resInference.getValues()[0];
		//System.out.println("prima variabili trovata --> "+firstVar);
		/*
		if(ProbabilityTable.varWithProb.containsKey(firstVar)) {
			ArrayList<RandomVariable> var = ProbabilityTable.varWithProb.get(firstVar);
			for (RandomVariable v : var) {
				resultVariables.add(v);
				ProbabilityTable.variables.remove(v);
			}
		}

		System.out.println("HASHMAP CON PROBABILITÀ E VARIABILI");
		Iterator iterator = ProbabilityTable.varWithProb.entrySet().iterator();
		while(iterator.hasNext()){
			Map.Entry entry = (Map.Entry) iterator.next();
			System.out.println("key --> "+entry.getKey());
			System.out.println("Value --> "+entry.getValue());
		}*/

		Iterator iter = ProbabilityTable.totRows.entrySet().iterator();
		while(iter.hasNext()){
			Map.Entry entry = (Map.Entry) iter.next();
			System.out.println("key --> "+entry.getKey());
			ArrayList<RandomVariable> var = (ArrayList<RandomVariable>) entry.getValue();
			for(RandomVariable v : var) {
				System.out.print(v.getName()+"("+v.getAssign()+") - ");
			}
			System.out.println();

		}
	}

	public static Factor eliminationVariable(aima.core.probability.bayes.BayesianNetwork bn, RandomVariable[] query, AssignmentProposition[] assig, int heuristic){
        List<RandomVariable> bnVars = bn.getVariablesInTopologicalOrder();
        //rimuove le irrelevant variables e ritorna le hidden variables
        Set<RandomVariable> hidden = EliminationAsk.calculateVariables(query, assig, bn, bnVars);

        for(Node vr : EliminationAsk.irrelevantList) {
            System.out.println("irrelevant: " + vr.getRandomVariable().getName());
            //bnVars.remove(vr);
        }

        //varElim contiene la lista ordinata di random variables
        List<RandomVariable> varElim = EliminationAsk.applyVariableElimination(query, assig, bn, bnVars ,heuristic);

        System.out.println();
        List<RandomVariable> remainingVars = new ArrayList<RandomVariable>(varElim);
        Graph graph = new Graph(bn,remainingVars);
        //trasformiamo da array a Set
        Set<Node> tempSetRv = new HashSet<>();
        for (int k=0;k<query.length;k++){
            tempSetRv.add(bn.getNode(query[k]));
        }
        Set<AssignmentProposition> tempSetE = new HashSet<>();
        for (int j=0;j<assig.length;j++){
            tempSetE.add(assig[j]);
        }
        List<Node> tempList = graph.getNotMSeparatedGraph(tempSetRv,tempSetE);
        //List<Node> tempList = graph.getGraph();

        System.out.println("dopo m separated");
        for(Node n : tempList){
            System.out.println(n.getRandomVariable().getName());
        }

        //tempListRv è la lista delle rv avendo eliminato le irrelevant e avendo applicato l'm-separated
        List<RandomVariable> tempListRv = new ArrayList<>();
        for(Node z : tempList){
            tempListRv.add(z.getRandomVariable());
        }

        List<Factor> tempFactors = new ArrayList<Factor>();
        for(RandomVariable rv : tempListRv){
            //System.out.println("var: "+var);
            // factors <- [MAKE-FACTOR(var, e) | factors]
            //System.out.println("makefactor: "+makeFactor(var, e, bn));
            tempFactors.add(0, EliminationAsk.makeFactor(rv, assig, bn));
        }


        List<Factor> factors = new ArrayList<>();

        for(Factor f : tempFactors){
            for(RandomVariable rv : f.getRandomVarInfo().keySet()){
                if(!EliminationAsk.irrelevantList.contains(bn.getNode(rv)) && !factors.contains(f)){
                    factors.add(f);
                }
            }
        }

        factors = EliminationAsk.sumOutVar(tempListRv,factors,hidden);

        System.out.println("----------------------------");

        Factor product = EliminationAsk.pointwiseProduct(factors);
        return product;
    }

    public static HashMap<String,List<String>> parseEvidenceDBN(String path) throws IOException {
        HashMap<String,List<String>> evidenceDBN = new HashMap<>();
        FileReader file = new FileReader(path);
        BufferedReader rete = new BufferedReader(file);
        List<String> values = new ArrayList<>();

        String delims = "[ ]+";
        String[] split;
        String line = rete.readLine();

        while (line != null) {
            split = line.split(delims);
            int i=1;
            while(i<split.length){
                values.add(split[i]);
                i++;
            }
            evidenceDBN.put(split[0],values);
            line = rete.readLine();
        }

        rete.close();
        file.close();

        return evidenceDBN;
    }

    public static BayesianNetwork removeEvidence(BayesianNetwork bn, String path_xmlbif) throws IOException {
	    BayesianNetwork bnNOEvidence;
	    List<RandomVariable> rv = bn.getVariablesInTopologicalOrder();
        List<RandomVariable> newbn = new ArrayList<>();
        newbn.addAll(rv);

	    for(RandomVariable r: rv){
	        for(AssignmentProposition ap : SupportStructureBN.assig){
	            if(ap.getTermVariable().getName().equals(r.getName()))
                    newbn.remove(r);
            }
        }

        bnNOEvidence = buildNetworkDBN(newbn, path_xmlbif);
	    return bnNOEvidence;
    }

	public static aima.core.probability.bayes.BayesianNetwork buildNetworkDBN(List<RandomVariable> newbn, String path) throws IOException {

		org.encog.ml.bayesian.BayesianNetwork bn = BIFUtil.readBIF(path);
        /*System.out.println(bn.toString());
        System.out.println("GETCONTENTS");
        System.out.println(bn.getContents());
        for(BayesianEvent event: bn.getEvents()) {
            System.out.println(event.getLabel()+" "+event.getTable().toString());
        }*/
        List<String> newbnString = new ArrayList<>();
        for(RandomVariable r: newbn){
            newbnString.add(r.getName());
        }

		//creo i FiniteNode per la rete
		List<FiniteNode> nodeList = new ArrayList<>();
		ArrayList<String> nodeNamesList = new ArrayList<>();
		Node[] ancestors;
		double[] values = null;
		String[] choices = null;
		ArrayList<String> nodeLabel = new ArrayList<>();
		int offset;
		for (BayesianEvent e : bn.getEvents()) {
            if (newbnString.contains(e.getLabel())){
                if (!e.hasParents()) {
                    values = new double[e.getTable().getLines().size()];
                    int z = 0;
                    for (TableLine tl : e.getTable().getLines()) {
                        values[z] = tl.getProbability();
                        z++;
                    }
                    choices = new String[e.getChoices().size()];
                    int q = 0;
                    for (BayesianChoice bc : e.getChoices()) {
                        choices[q] = bc.getLabel();
                        q++;
                    }
                    FiniteNode node = new FullCPTNode(new RandVar(e.getLabel(), new ArbitraryTokenDomain(choices)), values);
                    nodeNamesList.add(node.getRandomVariable().getName());
                    nodeLabel.add(node.getRandomVariable().getName());
                    nodeList.add(node);
                }
            }
		}

		ancestors = new Node[nodeList.size()];
		int i = 0;
		for (Node n : nodeList) {
			ancestors[i] = n;
			i++;
		}

		List<BayesianEvent> events = bn.getEvents();
		BayesianEvent[] eventsArray = new BayesianEvent[events.size()];
		int p=0;
		for(BayesianEvent be : events){
			eventsArray[p] = be;
			p++;
		}

		int k=0;
		while (k<eventsArray.length) {
			BayesianEvent e = eventsArray[k];
			//System.out.println("considero nodo " + e.getLabel());
			//controllo se ha i genitori
			if (e.hasParents()) {
				boolean flag = true;
				for (BayesianEvent par : e.getParents()) {
					if (!nodeNamesList.contains(par.getLabel())) {
						flag = false;
					}
				}
				if (flag) {
					FiniteNode[] parents = new FiniteNode[e.getParents().size()];
					int j = 0;
					for (BayesianEvent pe : e.getParents()) {
						for (FiniteNode n : nodeList) {
							if (n.getRandomVariable().getName().equals(pe.getLabel())) {
								parents[j] = n;
								j++;
							}
						}
					}
					offset = e.getChoices().size();
					//System.out.println("offset: "+offset);
					values = new double[e.getTable().getLines().size()];
					int x=0;
					for (int z=0; z<e.getTable().getLines().size(); z++) {
						//System.out.println(e.getLabel()+" "+z);
						values[z] = e.getTable().getLines().get(x).getProbability();
						//System.out.println("resto "+z%offset);
						if((z+1)%offset==0)
							z+=offset;
						x++;
					}
					//System.out.println("----------------------------");
					x=e.getTable().getLines().size()/2;
					for (int z=offset; z<e.getTable().getLines().size(); z++) {
						//System.out.println(z);
						values[z] = e.getTable().getLines().get(x).getProbability();
						if((z+1)%offset==0)
							z+=offset;
						x++;
					}
                    /*if(e.getLabel().equals("T")){
                        System.out.println(e.getTable().getLines().size());
                        for(int t=0; t<values.length; t++)
                            System.out.println(values[t]);
                    }*/
					choices = new String[e.getChoices().size()];
					int q = 0;
					for(BayesianChoice bc : e.getChoices()){
						choices[q] = bc.getLabel();
						q++;
					}

					//System.out.println("creo nodo " + e.getLabel());
					FiniteNode node = new FullCPTNode(new RandVar(e.getLabel(), new ArbitraryTokenDomain(choices)), values, parents);
					Set<Node> tempAncestors = new HashSet<>();
					for (Node parent : node.getParents()){
						if (parent.getAncestors()!=null) {
							tempAncestors.addAll(parent.getAncestors());
						}
						tempAncestors.add(parent);
					}
					node.setAncestors(tempAncestors);

					nodeList.add(node);
					nodeNamesList.add(node.getRandomVariable().getName());
					nodeLabel.add(node.getRandomVariable().getName());
					k++;
				} else {
					moveToLastPosition(eventsArray, k);
				}
			} else {
				k++;
			}
		}

		aima.core.probability.bayes.BayesianNetwork network = new BayesNet(ancestors);
		System.out.println("Nodi: "+network.getVariablesInTopologicalOrder()+"\n");

		//save(nodeLabel);

		return network;

	}
}