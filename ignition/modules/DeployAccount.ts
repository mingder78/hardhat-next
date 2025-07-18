import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("DeployAccount", (m) => {
  const entryPoint = "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"; // Replace with your actual EntryPoint address
  // Define an owner address (e.g., a test account)
  const owner = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"; // Example Hardhat test account
  const salt = m.getParameter("salt", "0x89c4940f9b688fe86a95d4d61bf5b43181b3f78c23bd04dbccf35bb5589783da"); // Use a fixed salt for CREATE2
  // Create the SimpleAccountFactory contract
  const factory = m.contract("SimpleAccountFactory", [entryPoint]);
  // Call createAccount on the factory to deploy a SimpleAccount
  const account = m.call(factory, "createAccount", [owner, salt], {
    id: "create_account",
  });

  return { factory, account };
});
