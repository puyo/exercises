import java.io.*;
import java.net.*;

class Client {
	
	private static String usage = "Usage: java Client <address>";

	private static BufferedReader userInStream = new BufferedReader(new InputStreamReader(System.in));

	private static final int PORTNUM = 1234;

	public static void main(String[] args) {

		BufferedReader serverInStream = null;
		PrintWriter serverOutStream = null;
		String serverInput = null;
		String clientInput = null;

		Socket socket = null;
		String address = null;

		// Check the command-line args for the host address
		if (args.length != 1) {
			System.out.println(usage);
			return;
		} else {
			address = args[0];
		}

		// Initialize the socket and streams
		try {
			socket = new Socket(address, PORTNUM);
			serverInStream = new BufferedReader(new InputStreamReader(new DataInputStream(socket.getInputStream())));
			serverOutStream = new PrintWriter(socket.getOutputStream());
		} catch (Exception e) {
			System.err.println("Exception: Could not connect to server: " + e.getMessage());
			System.exit(1);
		}

		// Process user input and server responses
		try {

			while ((serverInput = serverInStream.readLine()) != null) {

				System.out.println("Server: " + serverInput);

				if (serverInput.equals("Bye."))
					break;

				clientInput = userInStream.readLine();

				System.out.println("Client: " + clientInput);

				serverOutStream.println(clientInput);
				serverOutStream.flush();
			}

		} catch (Exception e) {
			System.err.println("Exception: error trying to talk to server: " + e.getMessage());
		}

		try {
			// Cleanup
			serverInStream.close();
			serverInStream.close();
			socket.close();

		} catch (Exception e) {
			System.err.println("Exception: error trying to disconnect from server: " + e.getMessage());
		}

	}
}
