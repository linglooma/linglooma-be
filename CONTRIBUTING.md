## 📌 How to Contribute
1. Create a new branch for your changes:
```
git checkout -b feature/my-awesome-feature
```
2. Make your changes following the coding standards.
3. Commit your changes with a clear message following the [commit conventions](https://www.conventionalcommits.org/en/v1.0.0/).

4. Run github actions locally with [act](https://github.com/nektos/act) to ensure your changes pass the CI/CD pipeline:
```
act
```

5. Push your branch to the repository:
```
git push origin feature/my-awesome-feature
```
6. Create a Pull Request to `main`.

## Golang guidelines
- Keep it simple stupid (KISS)
- Don't repeat yourself (DRY)
- Single responsibility principle (SRP)
- Use gofmt to format your code
- Use goimports to organize your imports
- Use go vet to check for errors
- Use go test to run your tests
- Use go mod to manage your dependencies
- Use go lint to lint your code
- DO NOT use `panic` unless it's a critical error
- DO NOT use `fmt.Println` for debugging, use `logger` in `worker` package instead
```