import React, { Component } from 'react';
import Web3 from 'web3'
import './App.css';
import LotteryPlace from '../abis/LotteryPlace.json'

//to run => npm run start

class App extends Component {

  
  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  //makes the connection with MetaMask
  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3
    // Load account
    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })

    const networkId = await web3.eth.net.getId()
    const networkData = LotteryPlace.networks[networkId]
    if(networkData) {
      const abi = LotteryPlace.abi //application binary interface
      const address = networkData.address
      const contract = new web3.eth.Contract(abi, address)
      this.setState({ contract:contract })
      const usersAmount = await contract.methods.getUsersAmount().call()
      const users = await contract.methods.getUsers().call()
      this.setState({ users:users, usersAmount:usersAmount })

      /*
      // Load Colors
      for (var i = 1; i <= totalSupply; i++) {
        const color = await contract.methods.colors(i - 1).call()
        this.setState({
          colors: [...this.state.colors, color]
        })
      }
      */
    } else {
      window.alert('Smart contract not deployed to detected network.')
    }
  }

  onSubmit = async event => {
      const web3 = window.web3
      event.preventDefault();
      const accounts = await web3.eth.getAccounts();
      const signFee = "0.001"
      this.setState({ message: "Waiting on transaction sucess ...." });
      await this.state.contract.methods.buyTicket().send({
        from: accounts[0],
        value: web3.utils.toWei(signFee, "ether")
      });
      const users = await LotteryPlace.methods.getUsers().call();
      
      this.setState({
        users: users,
        message: "Congratulation!!! You have successfully entered the lottery",
        usersAmount:this.state.usersAmount + 1
      });
    };


  constructor(props) {
    super(props)
    this.state = {
      account: '',
      contract: null,
      usersAmount: 0,
      users: []
    }
  }

  render() {
    return (
      <div>
        <h1>Lottery Contract</h1>
        <p>There are currently {this.state.users.length} people
          competing to win{" "}
          Ether !!!
        </p>
        <hr />
        <form onSubmit={this.onSubmit}>
          <h4> Want to try your Luck ???</h4>
          <div>
          </div>

          <button>Buy Ticket!</button>
        </form>

        <hr />

      </div>
    );
  }
}
export default App;
