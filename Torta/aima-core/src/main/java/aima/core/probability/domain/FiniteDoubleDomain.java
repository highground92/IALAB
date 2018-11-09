package aima.core.probability.domain;

import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

public class FiniteDoubleDomain extends AbstractDoubleDomain {

	private Set<Double> possibleValues = null;

	public FiniteDoubleDomain(Double... pValues) {
		// Keep consistent order
		possibleValues = new LinkedHashSet<Double>();
		for (Double v : pValues) {
			possibleValues.add(v);
		}
		// Ensure cannot be modified
		possibleValues = Collections.unmodifiableSet(possibleValues);

		indexPossibleValues(possibleValues);
	}

	//
	// START-Domain
	@Override
	public int size() {
		return possibleValues.size();
	}

	@Override
	public boolean isOrdered() {
		return true;
	}

	// END-Domain
	//

	//
	// START-DiscreteDomain
	@Override
	public Set<Double> getPossibleValues() {
		return possibleValues;
	}

	// END-DiscreteDomain
	//

	@Override
	public boolean equals(Object o) {

		if (this == o) {
			return true;
		}
		if (!(o instanceof FiniteDoubleDomain)) {
			return false;
		}

		FiniteDoubleDomain other = (FiniteDoubleDomain) o;

		return this.possibleValues.equals(other.possibleValues);
	}

	@Override
	public int hashCode() {
		return possibleValues.hashCode();
	}
}
