package aima.core.probability.bayes.impl;

import java.util.*;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.ConditionalProbabilityDistribution;
import aima.core.probability.bayes.Node;

/**
 * Abstract base implementation of the Node interface.
 * 
 * @author Ciaran O'Reilly
 * @author Ravi Mohan
 */
public abstract class AbstractNode implements Node {
	private RandomVariable variable = null;
	private Set<Node> parents = null;
	private Set<Node> children = null;
	private Set<Node> ancestors = null;

	private Set<Node> neighbors = new HashSet<Node>();
	private boolean mark = false;

	public AbstractNode(RandomVariable var) {
		this(var, (Node[]) null);
	}

	public AbstractNode(RandomVariable var, Node... parents) {
		if (null == var) {
			throw new IllegalArgumentException(
					"Random Variable for Node must be specified.");
		}
		this.variable = var;
		this.parents = new LinkedHashSet<Node>();
		if (null != parents) {
			for (Node p : parents) {
				((AbstractNode) p).addChild(this);
				this.parents.add(p);
			}
		}
		this.parents = Collections.unmodifiableSet(this.parents);
		this.children = Collections.unmodifiableSet(new LinkedHashSet<Node>());
	}

	public Set<Node> getAncestors(){
		return this.ancestors;
	}

	public void setAncestors(Set<Node> ancestors){
		this.ancestors = ancestors;
	}

	//
	// START-Node
	@Override
	public RandomVariable getRandomVariable() {
		return variable;
	}

	@Override
	public boolean isRoot() {
		return 0 == getParents().size();
	}

	@Override
	public Set<Node> getParents() {
		return parents;
	}

	@Override
	public Set<Node> getChildren() {
		return children;
	}

	@Override
	public Set<Node> getMarkovBlanket() {
		LinkedHashSet<Node> mb = new LinkedHashSet<Node>();
		// Given its parents,
		mb.addAll(getParents());
		// children,
		mb.addAll(getChildren());
		// and children's parents
		for (Node cn : getChildren()) {
			mb.addAll(cn.getParents());
		}

		return mb;
	}

	public abstract ConditionalProbabilityDistribution getCPD();

	// new methods
	@Override
	public void setNeighbors(Set<Node> node){
		for(Node n : node){
			this.neighbors.add(n);
		}
	}

	@Override
	public Set<Node> getNeighbors(){
		return this.neighbors;
	}

	@Override
	public void setMark(boolean m){
		this.mark = m;
	}

	public void setParents(Set<Node> parents){
		this.parents = parents;
	}

	public void setChildren(Set<Node> children) {
		for(Node n : children){
			this.addChild(n);
		}
	}

	@Override
	public boolean getMark(){
		return this.mark;
	}

	// END-Node
	//

	@Override
	public String toString() {
		return getRandomVariable().getName();
	}

	@Override
	public boolean equals(Object o) {
		if (null == o) {
			return false;
		}
		if (o == this) {
			return true;
		}

		if (o instanceof Node) {
			Node n = (Node) o;

			return getRandomVariable().equals(n.getRandomVariable());
		}

		return false;
	}

	@Override
	public int hashCode() {
		return variable.hashCode();
	}

	//
	// PROTECTED METHODS
	//
	protected void addChild(Node childNode) {
		children = new LinkedHashSet<Node>(children);

		children.add(childNode);

		children = Collections.unmodifiableSet(children);
	}

}
