// Call scale through an extern "C" declaration. Without extern "C" the
// compiler would emit a mangled name and the link to the Fortran symbol
// would fail. An exception is turned into an integer before it can leave
// this file.
#include <exception>
#include <iostream>
#include <vector>

extern "C" {
void scale(int n, double *x);
}

int checked_scale(std::vector<double> &x) {
  try {
    if (x.empty()) {
      throw std::runtime_error("empty");
    }
    scale(static_cast<int>(x.size()), x.data());
    return 0;
  } catch (const std::exception &) {
    return 1;
  }
}

int main() {
  std::vector<double> values{1.0, 2.0, 3.0};
  std::vector<double> empty;
  if (checked_scale(values) != 0) {
    return 1;
  }
  std::cout << "x =";
  for (double item : values) {
    std::cout << ' ' << static_cast<int>(item);
  }
  std::cout << '\n';
  std::cout << "empty status = " << checked_scale(empty) << '\n';
  return 0;
}
