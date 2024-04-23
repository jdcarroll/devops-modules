# South East Toyota Bicep Modules Repository

Welcome to the official repository for South East Toyota Bicep Modules! This repository is designed to house all the standard Bicep modules used within our DevOps processes, ensuring consistency and efficiency in our infrastructure deployments.

## Current Modules

### Storage Account Module

- **Purpose**: Provides a template for creating and managing Azure Storage Accounts.
- **Features**: Configurable parameters for account type, access tier, replication type, and more.

### Azure Container Registry (ACR) Module

- **Purpose**: Facilitates the creation and management of Azure Container Registries.
- **Features**: Configurable parameters to customize the registry name, SKU, georeplication locations, and network access rules.

## GitHub Action Integration

This repository is paired with a custom GitHub Action that simplifies the deployment process by handling both the cloning of the modules and their deployment.

### How It Works

1. **Action Setup**: The GitHub Action is set up to automatically clone this repository into the GitHub Workspace.
2. **Module Placement**: The cloned modules are stored under the directory named `modules`.
3. **Deployment**: The action takes the path to your Bicep file specified in the workflow and deploys it to Azure.

### Usage Instructions

To utilize this GitHub Action in your workflow, integrate the following step in your `.github/workflows` YAML file:

```yaml
steps:
  - name: Checkout
    uses: actions/checkout@v2

  - name: Deploy with Custom Action
    uses: your-github-username/custom-deploy-action@main
    with:
      bicep_path: path/to/your/bicep/file
```

Replace `your-github-username` and `bicep_path` with your specific details. Ensure that the action version (`@main`) corresponds to the current version in your repository.

## Contributing

We encourage contributions to this repository! Whether adding new modules, enhancing existing ones, or fixing bugs, here's how you can help:

1. **Fork the Repository**: Begin by forking this repository to your own GitHub account.
2. **Create a Feature Branch**: Make changes in a new branch named after the feature or bug fix.
3. **Commit Your Changes**: Ensure your commit messages clearly articulate the changes made.
4. **Submit a Pull Request**: Open a pull request from your forked repository back to this main repository with a detailed description of the changes and any relevant information.

## Support

For support issues or questions, please open an issue in this repository or contact the project maintainers directly.
