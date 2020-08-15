// Source for MyFunc.cpp
#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
NumericVector myFunc(DataFrame x) {
  NumericVector ids = x["id"];
  NumericVector intensidades = x["intensidad"];
  int n = ids.size();
  NumericVector res(n);
  for (int i=0; i<n; i++){
  	  int id = ids[i];
      res[id] = res[id] + intensidades[i];
  }
  return res;
}
